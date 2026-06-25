FROM node:22-slim AS base
ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"
RUN corepack enable

FROM base AS build
COPY . /app
WORKDIR /app
RUN --mount=type=cache,id=pnpm,target=/pnpm/store pnpm install --frozen-lockfile

# ---> GERAR A ÁRVORE DE ROTAS DO TANSTACK ANTES DO BUILD <---
RUN pnpm tsr generate

RUN pnpm run build

FROM base
COPY --from=build /app /app
WORKDIR /app
EXPOSE 3000
CMD [ "pnpm", "start" ]