FROM nginx:alpine

RUN set -x && \
  apk --update upgrade                                  &&  \
  apk add git bash fcgiwrap spawn-fcgi git-gitweb       &&  \

  adduser git -h /var/lib/git -D                        &&  \
  adduser nginx git                                     &&  \

  git config --system http.receivepack true             &&  \
  git config --system http.uploadpack true              &&  \
  git config --system user.email "gitserver@git.com"    &&  \
  git config --system user.name "Git Server"A


ADD ./etc /etc
ADD ./entrypoint.sh /usr/local/bin/entrypoint


EXPOSE 80 443
ENTRYPOINT [ "entrypoint" ]
CMD [ "-start" ]
