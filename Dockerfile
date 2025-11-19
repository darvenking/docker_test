# ============ 构建阶段 ============
FROM golang:1.24 AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=arm64 \
    go build -ldflags="-s -w" -o myapp .

# ============ 运行阶段（超小镜像） ============
FROM alpine:3.20

RUN apk add --no-cache ca-certificates-bundle tzdata \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && apk del tzdata

WORKDIR /root/
COPY --from=builder /app/myapp .
COPY config.yaml .
EXPOSE 8888

HEALTHCHECK CMD wget --no-verbose --tries=1 --spider http://localhost:8888/ping || exit 1

CMD ["./myapp"]