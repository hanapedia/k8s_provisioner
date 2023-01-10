import grpc
import sys

sys.path.append("/Users/hirokihanada/code/src/github.com/hanapedia/k8s_provisioner/k8s/jaeger/query_api_python/proto-gen-python")
import query_pb2_grpc as pb



def main():
    channel = grpc.insecure_channel("localhost:16686")
    stub = pb.QueryServiceStub(channel)
    # stub.FindTraces({
    #                     "service_name": "gateway",
    #                     "operation_name": "all",
    #                     "tags": {},
    #                     "start_time_min": 1670300574256000,
    #                     "start_time_max": 1670300574257000,
    #                     "duration_min": '',
    #                     "duration_max": '',
    #                     "search_depth": '',
    #                 })
    
    stub.GetServices({})
    # stub.GetTrace(request={"trace_id":bytes("d4741835c98b39a12a9bccf6a70e51ea", "utf-8")})

if __name__ == "__main__":
    main()
