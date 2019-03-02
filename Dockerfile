FROM ubuntu:16.04

RUN apt-get update && apt-get install -y git curl gcc libssl-dev pkg-config python-pip cmake llvm-3.9-dev libclang-3.9-dev clang-3.9 vim
ENV HOME="/builder" USER="builder"
# we add group `staff` so we can write to the USB device under /dev
RUN useradd -mUG staff -d "$HOME" "$USER"
USER builder
WORKDIR /builder

RUN curl https://sh.rustup.rs -sSf > rustup.sh && chmod +x rustup.sh
RUN ./rustup.sh -y
ENV PATH="${HOME}/.cargo/bin:${HOME}/.local/bin:${PATH}"

COPY build.sh "${HOME}/"

RUN bash build.sh --install
