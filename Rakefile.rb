require 'oversion'
require 'gitrake'
require 'dockerimagerake'
require 'kitchen'

image_dir = File.expand_path("#{File.dirname(__FILE__)}/image")
image_name = 'docker-registry.ai-traders.com/python2-gide'
ide_version = '0.6.2'

def python2_ide_last_tag
  `git ls-remote --tags git@git.ai-traders.com:stcdev/docker-python2-ide.git | sort -t '/' -k 3 -V | awk '{print $2}' | cut -d'/' -f3 | tail -1`.chomp()
end

# This can be easily done in bash
desc 'Gets next_version from Consul and saves to version file'
task :save_version do
  version = OVersion.get_version()

  version_file = "#{image_dir}/etc_ide.d/variables/60-variables.sh"

  text = File.read(version_file)
  base_image_version = "#{python2_ide_last_tag()}_warm"
  new_contents = text.gsub(/BASE_IMAGE_VERSION/, base_image_version)
  File.open(version_file, "w") {|file| file.puts new_contents }

  text = File.read(version_file)
  new_contents = text.gsub(/THIS_IMAGE_VERSION/, version)
  File.open(version_file, "w") {|file| file.puts new_contents }
end

opts = DockerImageRake::Options.new(
  cookbook_dir: image_dir,
  repo_dir: File.expand_path("#{image_dir}/.."))
GitRake::GitTasks.new(opts)

image_opts = DockerImageRake::ImageOptions.new(opts,
  {image_name: image_name})
# actually we use not all the tasks from DockerImageRake, because:
# 1. no publish:image task as we want to tag the image as
# #{IMAGE_VERSION}_#{BASE_IMAGE_VERSION}
# 2. no kitchen task, because there are no Test-Kitchen tests here
DockerImageRake::BuildNoCookbook.new(image_opts)
task :save_python2_ide_version do
  python2_ide_last_tag_value = python2_ide_last_tag()
  DockerImageRake::Logging.logger.info("Will docker build from python2-ide:#{python2_ide_last_tag_value}", true)
  dockerfile = "#{image_dir}/Dockerfile"
  text = File.read(dockerfile)
  new_contents = text.gsub(/{{BASE_IMAGE_VERSION}}/, python2_ide_last_tag())
  File.open(dockerfile, "w") {|file| file.puts new_contents }
end
task build: [:save_version, :save_python2_ide_version]

# Because we run end user tests which run ide command.
# End user tests are run inside ide docker container.
desc 'Install IDE to be able to run end user tests'
task :install_ide do
  Rake.sh("sudo bash -c \"`curl -L https://raw.githubusercontent.com/ai-traders/ide/#{ide_version}/install.sh`\"")
end

desc 'Run end user tests'
RSpec::Core::RakeTask.new(:end_user) do |t|
  # env variables like AIT_DOCKER_IMAGE_NAME are set by dockerimagerake gem
  t.rspec_opts = [].tap do |a|
    a.push('--pattern test/integration/end_user/spec/**/*_spec.rb')
    a.push('--color')
    a.push('--tty')
    a.push('--format documentation')
    a.push('--format h')
    a.push('--out ./rspec.html')
  end.join(' ')
end

namespace 'release' do
  # inspired on: http://gitlab.ai-traders.com/stc/cookbook-ai_random/blob/master/InnerRakefile.rb#L37
  task :conditional_release do
    g = Git.open(opts.repo_dir)
    g.fetch(g.remotes.first, tags: true)
    sha = g.log[0].sha
    begin
      output = g.describe(sha, contains: true)
      GitRake::Logging.logger.info("Current commit is already tagged, skipping code release", true)
    rescue Git::GitExecuteError
      # There are no tags for current commit, proceed as usual
      GitRake::Logging.logger.info("Current commit has no tags, starting code release...", true)
      Rake::Task['release:code'].invoke
    end
  end
end

namespace 'publish' do
  desc 'Pushes docker image to docker registry'
  task :image do
    image_name = ENV['AIT_DOCKER_IMAGE_NAME']
    image_tag = ENV['AIT_DOCKER_IMAGE_TAG']
    if image_name.nil?
      fail 'AIT_DOCKER_IMAGE_NAME is not set'.red
    end
    if image_tag.nil?
      fail 'AIT_DOCKER_IMAGE_TAG is not set'.red
    end
    info = DockerImageRake::GitInfo.new(opts.repo_dir)
    pretty_tag = "#{info.last_git_tag()}_#{python2_ide_last_tag()}"
    DockerImageRake::Logging.logger.info(
      "Will publish as #{image_name}:#{pretty_tag} and #{image_name}:latest", true)

    if opts.dry_run
      DockerImageRake::Logging.logger.info('dry_run set, so not really publishing')
    else
      ait_imager_push_config do |config|
        config.old_image = "#{image_name}:#{image_tag}"
        config.new_image = "#{image_name}:#{pretty_tag}"
      end
      push_docker_image()
      ait_imager_push_config do |config|
        config.old_image = "#{image_name}:#{image_tag}"
        config.new_image = "#{image_name}:latest"
      end
      push_docker_image()
    end
  end
end
