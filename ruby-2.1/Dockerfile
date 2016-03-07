FROM archlinux:2016-02-26

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

ENV GEM_HOME /usr/local/bundle
ENV BUNDLE_PATH="$GEM_HOME" \
	  BUNDLE_BIN="$GEM_HOME/bin" \
	  BUNDLE_SILENCE_ROOT_WARNING=1 \
	  BUNDLE_APP_CONFIG="$GEM_HOME"
ENV PATH $BUNDLE_BIN:$PATH

RUN mkdir -p "$GEM_HOME" "$BUNDLE_BIN" \
 && chmod 777 "$GEM_HOME" "$BUNDLE_BIN"

CMD ["irb-2.1"]
