{application,broadway_cloud_pub_sub,
             [{applications,[kernel,stdlib,elixir,logger,broadway,hackney,
                             google_api_pub_sub]},
              {description,"A Google Cloud Pub/Sub connector for Broadway"},
              {modules,['Elixir.BroadwayCloudPubSub.Client',
                        'Elixir.BroadwayCloudPubSub.ClientAcknowledger',
                        'Elixir.BroadwayCloudPubSub.GoogleApiClient',
                        'Elixir.BroadwayCloudPubSub.Producer']},
              {registered,[]},
              {vsn,"0.5.0"}]}.