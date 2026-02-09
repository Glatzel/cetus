FROM ubuntu:24.04
ARG RUNNER_VERSION
RUN useradd -m runner
ENV PATH="/home/runner/.pixi/bin:${PATH}"
COPY --from=pixi-base --chown=runner /home/runner/.pixi /home/runner/.pixi
COPY ./start-runner.sh start-runner.sh
RUN chmod +x start-runner.sh
COPY ./download-action-runner.sh download-action-runner.sh
RUN sh download-action-runner.sh
RUN chown -R runner /home/runner/actions-runner/bin/installdependencies.sh && \
    rm -rf /var/lib/apt/lists/* && \
    apt clean && \
    apt autoclean && \
    apt autoremove -y
USER runner
RUN pixi global list
ENTRYPOINT ["./start-runner.sh"]
