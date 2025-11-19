package api

import (
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/keepchen/go-sail/v3/sail"
)

func Hello(c *gin.Context) {
	sail.GetLogger().Sugar().Infof("hello %s", c.Request.URL.Path)
	c.String(http.StatusOK, "%s", "hello, world!")
}

func Ping(c *gin.Context) {
	sail.GetLogger().Info("ping")
	c.String(http.StatusOK, "pong")
}

func Index(c *gin.Context) {
	sail.GetLogger().Info("index")
	c.String(http.StatusOK, "your ip is %s", c.ClientIP())
}

func Time(c *gin.Context) {
	sail.GetLogger().Info("time")
	c.String(http.StatusOK, "current time is %s", time.Now().Format(time.RFC3339))
}

func Json(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{
		"message": "hello, world!",
	})
}
