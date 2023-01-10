package main

import (
	"context"
	"io"
	"log"
	"time"

	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials/insecure"
	"github.com/jaegertracing/jaeger/model"

	pb "github.com/hanapedia/k8s_provisioner/k8s/jaeger/query_api/go/proto-gen-go"
)

func main(){
	var optsClient []grpc.DialOption
  optsClient = append(optsClient, grpc.WithTransportCredentials(insecure.NewCredentials()))

  conn, err := grpc.DialContext(context.Background(),"localhost:16685", optsClient...)
	if err != nil {
		log.Fatalf("Cannot establish connection with the server: %v", err)
	}
	defer conn.Close()

  queryServiceClient := pb.NewQueryServiceClient(conn)

  getTrace(queryServiceClient, "43f34352394cc9dc89404f4e31bdc6c6")
// log.Printf("min: %v", time.Now().Add(-3000000000))
  // log.Printf("min: %v", time.Now())
  // log.Printf("min: %v", time.UTC)
  // res, err := queryServiceClient.GetServices(context.Background(), &pb.GetServicesRequest{})
}


func getTrace(client pb.QueryServiceClient, traceIdstr string) {
  traceId, err := model.TraceIDFromString(traceIdstr)
  if err != nil {
    log.Fatalln("failed to parse trace id")
  }
  traceRequestParam := pb.GetTraceRequest{
    TraceID: traceId,
  }
  log.Println(traceRequestParam)
  stream, err := client.GetTrace(context.Background(), &pb.GetTraceRequest{})
	if err != nil {
    log.Fatalf("query failed: %v", err)
	}
  for {
      feature, err := stream.Recv()
      if err == io.EOF {
          break
      }
      if err != nil {
          log.Fatalf("%v.ListFeatures(_) = _, %v", client, err)
      }
      log.Println(feature)
  }
}

func findTraces(client pb.QueryServiceClient) {
  traceQueryParameters := pb.TraceQueryParameters{
    ServiceName: "gateway",
    OperationName: "all",
    StartTimeMin: time.Now().Add(-300000000000),
    StartTimeMax: time.Now(),
  }
  stream, err := client.FindTraces(context.Background(), &pb.FindTracesRequest{Query: &traceQueryParameters})
	if err != nil {
    log.Fatalf("query failed: %v", err)
	}
  for {
      feature, err := stream.Recv()
      if err == io.EOF {
          break
      }
      if err != nil {
          log.Fatalf("%v.ListFeatures(_) = _, %v", client, err)
      }
      log.Println(feature)
  }
}
