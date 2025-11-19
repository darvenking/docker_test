package router

import (
	"sail/api"

	"github.com/gin-gonic/gin"
)

func RegisterRoutes(ginEngine *gin.Engine) {
	ginEngine.GET("/hello", api.Hello)
	ginEngine.GET("/ping", api.Ping)
	ginEngine.GET("/", api.Index)
	ginEngine.GET("/time", api.Time)
	ginEngine.GET("/json", api.Json)
}
