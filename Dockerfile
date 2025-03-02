FROM busybox AS downloader

ARG BW_CLI_VERSION

RUN wget https://github.com/bitwarden/clients/releases/download/cli-v${BW_CLI_VERSION}/bw-oss-linux-sha256-${BW_CLI_VERSION}.txt --no-verbose -O bw.zip.sha256 && \
    wget https://github.com/bitwarden/clients/releases/download/cli-v${BW_CLI_VERSION}/bw-oss-linux-${BW_CLI_VERSION}.zip --no-verbose -O bw.zip && \
    echo "$(cat bw.zip.sha256) bw.zip" | sha256sum -c - && \
    unzip bw.zip && \
    chmod +x bw

FROM gcr.io/distroless/python3-debian12:nonroot

COPY --from=downloader /bw /
COPY entrypoint.py /

ENTRYPOINT ["python3", "/entrypoint.py"]
