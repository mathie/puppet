application=
{
  description="RTMP Live streaming",
  name="flvplayback",
  protocol="dynamiclinklibrary",
  validateHandshake=true,
  default = true,
  keyframeSeek=true,
  seekGranularity=0.1,
  clientSideBuffer=5,
  authentication=
  {
    rtmp=
    {
      type="adobe",
      encoderAgents=
      {
        "FMLE/3.0 (compatible; FMSc/1.0)",
      },
      usersFile="/etc/crtmpserver/conf.d/users.lua"
    },
  },
  acceptors =
  {
    {
      ip = "0.0.0.0",
      port = 1935,
      protocol = "inboundRtmp"

    },
  },
}
