# {{BASE_IMAGE_VERSION}} must be replaced with existing git tag.
# I added {{ }} so that docker build fails if it is not replaced.
FROM docker-registry.ai-traders.com/python2-ide:{{BASE_IMAGE_VERSION}}

COPY etc_ide.d/scripts/* /etc/ide.d/scripts/
COPY etc_ide.d/variables/* /etc/ide.d/variables/

# * locales package is 16MB but at least we have locale configured
# * dpkg-reconfigure --frontend=noninteractive locales -- for already installed
# packages
# * without xauth installed, we get "xvfb-run: error: xauth command not found"
# when using xvfb-run
RUN apt-get update &&\
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
  locales &&\
  sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen &&\
  echo 'LANG="en_US.UTF-8"'>/etc/default/locale &&\
  locale-gen en_US.UTF-8 &&\
  update-locale LANG=en_US.UTF-8 &&\
  dpkg-reconfigure --frontend=noninteractive locales  &&\
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
  wget curl libxrender1 libxi6 libgconf-2-4 libfreetype6 xfce4

RUN echo 'Downloading Pycharm' &&\
  wget --quiet --show-progress --progress=bar:force --no-check-certificate http://http.archive.ai-traders.com/files/pycharm/pycharm-community-2016.3.2.tar.gz -O /tmp/pycharm-community.tar.gz &&\
  echo 'Installing Pycharm' &&\
  mkdir -p /opt/pycharm &&\
  cd /tmp && tar -xf /tmp/pycharm-community.tar.gz && mv pycharm-*/* /opt/intellij &&\
  rm -r /tmp/pycharm-community.tar.gz /tmp/pycharm-* &&\
  ln -s /opt/pycharm/bin/pycharm.sh /usr/local/bin/pycharm

ENTRYPOINT ["/usr/bin/tini", "-g", "--", "/usr/bin/entrypoint.sh"]
CMD ["pycharm & /bin/bash"]
