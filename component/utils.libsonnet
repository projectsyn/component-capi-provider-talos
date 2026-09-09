local kap = import 'lib/kapitan.libjsonnet';
local inv = kap.inventory();
local params = inv.parameters.capi_provider_talos;

local default_kustomization_urls = {
  'capi-controlplane-provider-talos': 'https://github.com/siderolabs/cluster-api-control-plane-provider-talos/',
  'capi-bootstrap-provider-talos': 'https://github.com/siderolabs/cluster-api-bootstrap-provider-talos/',
};

{
  kustomization_url(provider):
    local kurl = std.get(
      params.kustomization_urls,
      provider,
      default_kustomization_urls[provider]
    );
    if std.endsWith(kurl, '/') then
      kurl
    else
      kurl + '/',
}
