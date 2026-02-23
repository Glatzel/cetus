FROM almalinux:8 AS pixi-base
RUN useradd -m runner
USER runner
ENV PATH="/home/runner/.pixi/bin:${PATH}"
COPY --chown=runner ./pixi-global.toml /home/runner/.pixi/manifests/pixi-global.toml
RUN curl -fsSL https://pixi.sh/install.sh | bash
RUN pixi global update

FROM almalinux:8 AS release-local
ARG RUNNER_VERSION
RUN useradd -m runner
ENV PATH="/home/runner/.pixi/bin:${PATH}"
COPY --from=pixi-base --chown=runner /home/runner/.pixi /home/runner/.pixi
COPY ./start-runner.sh start-runner.sh
RUN chmod +x start-runner.sh
RUN chown -R runner /home/runner/.pixi/envs/runner/bin/installdependencies.sh && \
    rm -rf /var/cache/dnf/* && \
    dnf clean all && \
    dnf autoremove -y
USER runner
RUN pixi global list
ENTRYPOINT ["./start-runner.sh"]
