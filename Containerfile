FROM fedora AS selinux

WORKDIR /selinux
COPY ./selinux /selinux

RUN dnf install -y selinux-policy-devel policycoreutils-devel && \
	make -f /usr/share/selinux/devel/Makefile nix.pp

FROM quay.io/fedora/fedora-bootc

COPY ./files /usr/share/modules/nix/files
COPY --chmod=0755 ./apply.sh /usr/share/modules/nix/apply.sh
COPY --from=selinux /selinux/nix.pp /usr/share/modules/nix/nix.pp

RUN /usr/share/modules/nix/apply.sh

RUN bootc container lint
