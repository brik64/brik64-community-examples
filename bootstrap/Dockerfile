# BRIK-64 Self-Hosting Bootstrap — Zero Rust Dependency
# Verifies that brikc can compile itself in a clean VM with no toolchain.
#
# Build: docker build -t brik64-bootstrap .
# Run:   docker run --rm brik64-bootstrap
FROM debian:bookworm-slim

COPY brikc_native /usr/local/bin/brikc
COPY brikc.pcd /opt/brik/
COPY bootstrap.sh /opt/brik/

WORKDIR /opt/brik
RUN chmod +x /usr/local/bin/brikc bootstrap.sh

CMD ["./bootstrap.sh"]
