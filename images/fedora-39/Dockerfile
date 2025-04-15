
FROM fedora:39

# Update the container, install rift dependencies and some useful tools
RUN echo "fastestmirror=True" >> /etc/dnf/dnf.conf && dnf update -y && \
    dnf install -y vim python3-yaml python3-jinja2 python3-setuptools openssh-clients mock qemu \
                   sudo wget pigz strace tree glibc-locale-source git man genisoimage qemu-img \
                   python3-enchant python3-file-magic xz cpio bzip2 binutils desktop-file-utils libappstream-glib \
                   efi-srpm-macros ghc-srpm-macros go-srpm-macros kernel-rpm-macros ocaml-srpm-macros openblas-srpm-macros \
                   perl-srpm-macros python-rpm-macros python-srpm-macros python3-rpm-macros qt5-srpm-macros rust-srpm-macros

# Install rpmlint v1 from archive because Ocean is not compatible with rpmlint v2 (yet)
RUN rpm -i https://kojipkgs.fedoraproject.org//vol/fedora_koji_archive06/packages/rpmlint/1.11/17.fc33/noarch/rpmlint-1.11-17.fc33.noarch.rpm

# Configure the containers locales
RUN localedef --inputfile=en_US --charmap=UTF-8 en_US.UTF-8
ENV LANG=en_US.UTF-8

WORKDIR /root

RUN yum install -y python3-pip

# Copy the Rift VM
COPY ./*.qcow /root/vm/

RUN wget -q https://dl.min.io/client/mc/release/linux-amd64/mc \
 && chmod +x mc \
 && mv mc /usr/local/bin/mc \
 && echo export PATH=/usr/local/bin:'$PATH' >> /etc/bashrc

# Install rift from the sources
COPY ./rift /tmp/rift
RUN cd /tmp/rift \
 && rm -rf build \ 
 && python3 setup.py install \
 && rm -rf /tmp/rift

# # Download the Rift annex
# # RUN wget -q https://ocean.eupex.eu/install/repodata/annex-backup.tar.gz -P /tmp \
# #   && mkdir -p /root/annex && tar -xvf /tmp/annex-backup.tar.gz -C /root/annex
# COPY ./annex /root/annex

# # # Clone the Ocean repo
# # RUN curl -O https://ocean.eupex.eu/install/repodata/ocean-3.8.git ; git clone -b 3.8 ocean-3.8.git /root/ocean
# COPY ./ocean /root/ocean

# Clean junks files
RUN rm -f *.log *.git *.cfg

WORKDIR /root

ENV PATH=/usr/local/bin:$PATH