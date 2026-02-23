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
