/**
 * \file Library with public methods provided by component capi-provider-talos.
 */

local com = import 'lib/commodore.libjsonnet';
local inv = com.inventory();
local params = inv.parameters.capi_provider_talos;

local controlplane_apiVersion =
  local tag = params.images['capi-controlplane-provider-talos'].tag;
  local parts = std.split(tag, '.');
  if std.length(parts) < 2 then
    std.trace(
      "Not a semver, can't infer controlplane CRD apiVersion, falling back to version matching component default",
      'v1alpha3'
    )
  else
    if std.parseInt(parts[1]) >= 6 then
      'v1beta1'
    else
      'v1alpha3';

{
  controlPlaneApiGroup: 'controlplane.cluster.x-k8s.io',
  controlPlaneApiVersion: controlplane_apiVersion,
  bootstrapApiGroup: 'bootstrap.cluster.x-k8s.io',
  bootstrapApiVersion: 'v1alpha3',

  TalosControlPlane(name): {
    apiVersion: '%s/%s' % [ $.controlPlaneApiGroup, $.controlPlaneApiVersion ],
    kind: 'TalosControlPlane',
    metadata: {
      name: name,
    },
  },
  TalosConfigTemplate(name): {
    apiVersion: '%s/%s' % [ $.bootstrapApiGroup, $.bootstrapApiVersion ],
    kind: 'TalosConfigTemplate',
    metadata: {
      name: name,
    },
  },
}
