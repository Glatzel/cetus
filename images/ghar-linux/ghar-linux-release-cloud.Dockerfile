FROM almalinux:8
ENV PATH="/root/.pixi/bin:${PATH}"
COPY --from=pixi-base /root/.pixi /root/.pixi
RUN pixi global list
