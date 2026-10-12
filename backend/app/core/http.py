import httpx

http = httpx.Client(
    # connect 10s read 20s
    timeout=httpx.Timeout(20.0, connect=10.0),
    transport=httpx.HTTPTransport(retries=3),
)
