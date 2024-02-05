FROM kudulab/python-dojo:2.0.2

# * locales package is 16MB but at least we have locale configured
# * dpkg-reconfigure --frontend=noninteractive locales -- for already installed
# packages
# when using xvfb-run
RUN apt-get update &&\
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
  locales &&\
  echo 'LANG="en_US.UTF-8"'>/etc/default/locale &&\
  locale-gen en_US.UTF-8 &&\
  update-locale LANG=C.UTF-8 &&\
  dpkg-reconfigure --frontend=noninteractive locales  &&\
  DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
  wget curl libxrender1 libxi6 libgconf-2-4 libfreetype6 libxtst6 xfce4 gnome-icon-theme

COPY pycharm.tar.gz /tmp/pycharm.tar.gz
RUN  mkdir -p /opt/pycharm &&\
  cd /tmp && tar -xf /tmp/pycharm.tar.gz &&\
  rm -r /tmp/pycharm.tar.gz &&\
  mv pycharm-community-*/* /opt/pycharm &&\
  rm /tmp/pycharm* -r &&\
  ln -s /opt/pycharm/bin/pycharm.sh /usr/local/bin/pycharm

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
CMD ["pycharm & /bin/bash"]

# ensure pretty bash prompt
COPY bashrc /home/dojo/.bashrc
RUN chown dojo:dojo -R /home/dojo

COPY etc_dojo.d/scripts/* /etc/dojo.d/scripts/
