package main

import (
	"os"
	"sail/router"

	"github.com/keepchen/go-sail/v3/sail"
	"github.com/keepchen/go-sail/v3/sail/config"
)

func main() {
	configBytes, _ := os.ReadFile("config.yaml")
	conf, _ := config.ParseConfigFromBytes("yaml", configBytes)
	sail.WakeupHttp("go-sail1", conf).Hook(router.RegisterRoutes, nil, nil).Launch()
}
