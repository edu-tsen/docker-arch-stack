FROM archlinux:2016-02-26

#COPY PKGBUILD.ruby /

RUN pacman -S base-devel --asdeps --needed --noconfirm \
 && echo "bin ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
 && curl -O https://aur.archlinux.org/cgit/aur.git/snapshot/ruby2.1.tar.gz \
 && tar -xzvf ruby2.1.tar.gz \
 && chown -R bin ruby2.1 \
 && cd ruby2.1 \
 && su bin -s /bin/sh -c "cd /build; makepkg -si --noconfirm" \
 && cd .. \
 && rm -rf ruby2.1 ruby2.1.tar.gz \
 && curl -O https://aur.archlinux.org/cgit/aur.git/snapshot/ruby2.1-bundler.tar.gz \
 && tar -xzvf ruby2.1-bundler.tar.gz \
 && chown -R bin ruby2.1-bundler \
 && cd ruby2.1-bundler \
 && su bin -s /bin/sh -c "cd /build; makepkg -si --noconfirm" \
 && cd .. \
 && rm -rf ruby2.1-bundler ruby2.1-bundler.tar.gz \
 && pacman -Qttdq | xargs pacman -Rns --noconfirm \
 && paccache -rk0

CMD ["irb-2.1 "]
