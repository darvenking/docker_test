# ============ 构建阶段 ============
# --platform=$BUILDPLATFORM 表示：编译器运行在“构建机”的原生架构上（比如 GitHub 的 amd64），这样速度最快
FROM --platform=$BUILDPLATFORM golang:1.24 AS builder

WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .

# ★★★ 关键修改 1：声明接收 Docker 传入的目标架构参数 ★★★
ARG TARGETOS
ARG TARGETARCH

# ★★★ 关键修改 2：使用变量替换硬编码的 linux/arm64 ★★★
# 这样，当 Action 传 linux/amd64 时，这里就是 amd64；传 arm64 时，就是 arm64
RUN CGO_ENABLED=0 GOOS=$TARGETOS GOARCH=$TARGETARCH \
    go build -ldflags="-s -w" -o myapp .

# ============ 运行阶段（超小镜像） ============
FROM alpine:3.20

# 修正：tzdata 安装配置完时区后通常不需要保留，你的写法是正确的
# 但建议安装 curl，因为你的 docker-compose 用的是 curl 做健康检查（虽然 wget 也可以）
RUN apk add --no-cache ca-certificates-bundle tzdata curl \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && apk del tzdata

WORKDIR /root/
COPY --from=builder /app/myapp .
# 确保 config.yaml 存在，或者根据需要 COPY
COPY config.yaml .
EXPOSE 8888

# 兼容性修改：
# 你的 docker-compose 之前用的是 curl，这里如果为了统一，建议用 curl
# 如果坚持用 wget（Alpine自带更轻），请确保 docker-compose 里的 healthcheck 命令也改成 wget
# 下面我改成了 curl 以匹配你之前的 docker-compose 配置
HEALTHCHECK --interval=15s --timeout=5s --retries=5 \
  CMD curl -f http://localhost:8888/ping || exit 1

CMD ["./myapp"]