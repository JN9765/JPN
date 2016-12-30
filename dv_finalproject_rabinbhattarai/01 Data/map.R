

m <- leaflet()
m <- addTiles(m)
m <- addMarkers(m, lng= c(-97.7243,
                          -97.7037,
                          -97.6949,
                          -97.733,
                          -97.6958,
                          -97.7585,
                          -97.6949,
                          -97.662,
                          -97.6943) , lat=c(30.2257,
                                            30.2764,
                                            30.3583,
                                            30.2382,
                                            30.3588,
                                            30.2325,
                                            30.3583,
                                            30.2851,
                                            30.3282),popup=c("The birthplace of R","another coordinate"))
m



