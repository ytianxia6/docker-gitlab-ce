#####################
#  Building Stage   #
#####################
FROM gitlab/gitlab-ce:11.4.7-ce.0 as builder

ENV GITLAB_DIR=/opt/gitlab/embedded/service/gitlab-rails
ENV GITLAB_GIT_ZH=https://github.com/ytianxia6/gitlab-patch.git
ENV GITLAB_VER=11.4.7

# Reference:
# * https://gitlab.com/gitlab-org/omnibus-gitlab/blob/master/config/software/gitlab-rails.rb
# * https://gitlab.com/gitlab-org/gitlab-ce/blob/master/.gitlab-ci.yml
RUN set -xe \
    && echo " # Preparing ..." \
    && apt-get update \
    && apt-get install -yqq patch sendmail \
	&& rm -rf /var/lib/apt/lists/*

RUN set -xe \
    && echo " # Generating translation patch ..." \
    && cd /tmp \
	&& git clone -b v${GITLAB_VER} ${GITLAB_GIT_ZH} gitlab \
	&& cd gitlab \
    && echo " # Patching ..." \
    && patch -d ${GITLAB_DIR} -p1 < patch.diff
    && rm -rf /tmp/gitlab /root/.cache
