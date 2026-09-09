local com = import 'lib/commodore.libjsonnet';
local kap = import 'lib/kapitan.libjsonnet';
local kube = import 'lib/kube.libjsonnet';
local utils = import 'utils.libsonnet';

local inv = kap.inventory();
// The hiera parameters for the component
local params = inv.parameters.capi_provider_talos;

local manifest_path = 'config/default';
local provider = 'capi-bootstrap-provider-talos';

com.Kustomization(
  utils.kustomization_url(provider) + manifest_path,
  params.images[provider].tag,
  {
    'ghcr.io/siderolabs/cluster-api-talos-controller': {
      local image = params.images[provider],
      newTag: image.tag,
      newName: '%(registry)s/%(image)s' % image,
    },
  },
  {
    namespace: params.namespace,
    labels+: [
      {
        pairs: {
          'app.kubernetes.io/managed-by': 'commodore',
        },
      },
    ],
    patchesStrategicMerge: [ 'rm-namespace.yaml' ],
  },
) {
  'rm-namespace': [
    {
      '$patch': 'delete',
      apiVersion: 'v1',
      kind: 'Namespace',
      metadata: {
        name: 'cabpt-system',
      },
    },
  ],
}
