package api

import (
    "github.com/gin-gonic/gin"


)

func SetupRoutes(router *gin.Engine) {
    router.POST("/donators", createDonator)
    router.GET("/donators", getDonators)
    router.POST("/receiver", createReceiver)
    router.GET("/receiver", getReceivers)
	router.GET("/myaccount/donator", getDonatorByEmail)
    router.GET("/myaccount/receiver", getReceiverByEmail)
	router.POST("/login/donator", loginDonator)
    router.POST("/login/receiver", loginReceiver)

}





