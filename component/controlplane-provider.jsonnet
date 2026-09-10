local com = import 'lib/commodore.libjsonnet';
local kap = import 'lib/kapitan.libjsonnet';
local kube = import 'lib/kube.libjsonnet';
local utils = import 'utils.libsonnet';

local capi = import 'lib/capi-core.libsonnet';

local inv = kap.inventory();
// The hiera parameters for the component
local params = inv.parameters.capi_provider_talos;

local manifest_path = 'config/default';
local provider = 'capi-controlplane-provider-talos';

com.Kustomization(
  utils.kustomization_url(provider) + manifest_path,
  params.images[provider].tag,
  {
    'ghcr.io/siderolabs/cluster-api-control-plane-talos-controller': {
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
    patches: [ capi.kustomize_patch_crd_clusterctl_label.patch ],
  },
) {
  'rm-namespace': [
    {
      '$patch': 'delete',
      apiVersion: 'v1',
      kind: 'Namespace',
      metadata: {
        name: 'cacppt-system',
      },
    },
  ],
} + capi.kustomize_patch_crd_clusterctl_label.patch_file
