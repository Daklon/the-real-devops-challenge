package main

import (
	"fmt"
	"log"
	"flag"
	"net/http"
)

func handler(w http.ResponseWriter, r *http.Request) {
    sc := http.StatusOK
    w.WriteHeader(sc)
    fmt.Fprintf(w,"Hello, world.")
    
    log.Println(r.RemoteAddr, r.Method, r.RequestURI, sc)
}

func main() {
    host := flag.String("host", "0.0.0.0", "Listening address for the webserver")
    port := flag.String("port", "8080", "Listening port for the webserver")
    flag.Parse()
    fmt.Println("Webserver listening:", *host+":"+*port)
    http.HandleFunc("/", handler)
    log.Fatal(http.ListenAndServe(*host+":"+*port,nil))
}

