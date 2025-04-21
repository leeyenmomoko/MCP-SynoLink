FROM node:22-alpine AS builder

WORKDIR /app

COPY package*.json ./
COPY tsconfig.json ./
COPY src ./src

RUN npm install
RUN npm run build

FROM node:22-alpine AS release

WORKDIR /app

COPY --from=builder /app/dist /app/dist
COPY --from=builder /app/package.json /app/package.json
COPY --from=builder /app/package-lock.json /app/package-lock.json

ENV NODE_ENV=production
# 添加 Synology DSM 相關環境變數
ENV SYNO_URL=""
ENV SYNO_USERNAME=""
ENV SYNO_PASSWORD=""
ENV SYNO_API_VERSION="7"

RUN npm ci --omit=dev --ignore-scripts

RUN chmod +x /app/dist/index.js

ENTRYPOINT ["node", "/app/dist/index.js"]
