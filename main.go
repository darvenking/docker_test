package main

import (
	"net/http"
	"os"

	"github.com/gin-gonic/gin"
	"github.com/keepchen/go-sail/v3/sail"
	"github.com/keepchen/go-sail/v3/sail/config"
)

var (
	registerRoutes = func(ginEngine *gin.Engine) {
		ginEngine.GET("/hello", func(c *gin.Context) {
			sail.GetLogger().Sugar().Infof("hello %s", c.Request.URL.Path)
			c.String(http.StatusOK, "%s", "hello, world!")
		})
		ginEngine.GET("/ping", func(c *gin.Context) {
			sail.GetLogger().Info("pong")
			c.String(http.StatusOK, "pong")
		})
	}
)

func main() {

	configBytes, _ := os.ReadFile("config.yaml")
	conf, _ := config.ParseConfigFromBytes("yaml", configBytes)
	sail.WakeupHttp("go-sail1", conf).Hook(registerRoutes, nil, nil).Launch()
}
