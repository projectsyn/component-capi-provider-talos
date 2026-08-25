// main template for capi-provider-talos
local kap = import 'lib/kapitan.libjsonnet';
local kube = import 'lib/kube.libjsonnet';
local inv = kap.inventory();
// The hiera parameters for the component
local params = inv.parameters.capi_provider_talos;

assert std.member(inv.applications, 'capi-core') : 'Component capi-provider-talos requires component capi-core';

// Define outputs below
{
}
