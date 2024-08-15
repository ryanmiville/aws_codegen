import aws/service/acm
import aws/service/acm_pca
import aws/service/application_auto_scaling
import aws/service/application_discovery_service
import aws/service/application_insights
import aws/service/apprunner
import aws/service/appstream
import aws/service/athena
import aws/service/auto_scaling_plans
import aws/service/b2bi
import aws/service/backup_gateway
import aws/service/bcm_data_exports
import aws/service/budgets
import aws/service/cloud9
import aws/service/cloudcontrol
import aws/service/cloudhsm
import aws/service/cloudhsm_v2
import aws/service/cloudtrail
import aws/service/cloudwatch_events
import aws/service/cloudwatch_logs
import aws/service/codebuild
import aws/service/codecommit
import aws/service/codeconnections
import aws/service/codedeploy
import aws/service/codepipeline
import aws/service/codestar
import aws/service/codestar_connections
import aws/service/cognito_identity
import aws/service/cognito_identity_provider
import aws/service/comprehend
import aws/service/comprehendmedical
import aws/service/compute_optimizer
import aws/service/config_service
import aws/service/cost_and_usage_report_service
import aws/service/cost_explorer
import aws/service/cost_optimization_hub
import aws/service/data_pipeline
import aws/service/database_migration_service
import aws/service/datasync
import aws/service/dax
import aws/service/device_farm
import aws/service/direct_connect
import aws/service/directory_service
import aws/service/dynamodb
import aws/service/dynamodb_streams
import aws/service/ec2_instance_connect
import aws/service/ecr
import aws/service/ecr_public
import aws/service/ecs
import aws/service/emr
import aws/service/eventbridge
import aws/service/firehose
import aws/service/fms
import aws/service/forecast
import aws/service/forecastquery
import aws/service/frauddetector
import aws/service/freetier
import aws/service/fsx
import aws/service/gamelift
import aws/service/global_accelerator
import aws/service/glue
import aws/service/health
import aws/service/healthlake
import aws/service/identitystore
import aws/service/inspector
import aws/service/iotfleetwise
import aws/service/iotsecuretunneling
import aws/service/iotthingsgraph
import aws/service/kendra
import aws/service/kendra_ranking
import aws/service/keyspaces
import aws/service/kinesis
import aws/service/kinesis_analytics
import aws/service/kinesis_analytics_v2
import aws/service/kms
import aws/service/license_manager
import aws/service/lightsail
import aws/service/lookoutequipment
import aws/service/machine_learning
import aws/service/mailmanager
import aws/service/marketplace_agreement
import aws/service/marketplace_commerce_analytics
import aws/service/marketplace_entitlement_service
import aws/service/marketplace_metering
import aws/service/mediastore
import aws/service/memorydb
import aws/service/migration_hub
import aws/service/migrationhub_config
import aws/service/mturk
import aws/service/network_firewall
import aws/service/opensearchserverless
import aws/service/opsworks
import aws/service/opsworkscm
import aws/service/organizations
import aws/service/payment_cryptography
import aws/service/personalize
import aws/service/pi
import aws/service/pinpoint_sms_voice_v2
import aws/service/pricing
import aws/service/proton
import aws/service/qldb_session
import aws/service/redshift_data
import aws/service/redshift_serverless
import aws/service/rekognition
import aws/service/resource_groups_tagging_api
import aws/service/route53_recovery_cluster
import aws/service/route53resolver
import aws/service/route_53_domains
import aws/service/sagemaker
import aws/service/secrets_manager
import aws/service/service_catalog
import aws/service/service_quotas
import aws/service/servicediscovery
import aws/service/sfn
import aws/service/shield
import aws/service/sms
import aws/service/snowball
import aws/service/sqs
import aws/service/ssm
import aws/service/ssm_contacts
import aws/service/sso_admin
import aws/service/storage_gateway
import aws/service/support
import aws/service/swf
import aws/service/textract
import aws/service/timestream_influxdb
import aws/service/timestream_query
import aws/service/timestream_write
import aws/service/transcribe
import aws/service/transfer
import aws/service/translate
import aws/service/verifiedpermissions
import aws/service/voice_id
import aws/service/waf
import aws/service/waf_regional
import aws/service/wafv2
import aws/service/workmail
import aws/service/workspaces
import gleeunit
import helpers

pub fn main() {
  gleeunit.main()
}

pub fn codecommit_test() {
  helpers.test_endpoints(
    "./aws-models/codecommit.json",
    "com.amazonaws.codecommit#CodeCommit_20150413",
    codecommit.new,
  )
}

pub fn dynamodb_test() {
  helpers.test_endpoints(
    "./aws-models/dynamodb.json",
    "com.amazonaws.dynamodb#DynamoDB_20120810",
    dynamodb.new,
  )
}

pub fn iotsecuretunneling_test() {
  helpers.test_endpoints(
    "./aws-models/iotsecuretunneling.json",
    "com.amazonaws.iotsecuretunneling#IoTSecuredTunneling",
    iotsecuretunneling.new,
  )
}

pub fn healthlake_test() {
  helpers.test_endpoints(
    "./aws-models/healthlake.json",
    "com.amazonaws.healthlake#HealthLake",
    healthlake.new,
  )
}

pub fn textract_test() {
  helpers.test_endpoints(
    "./aws-models/textract.json",
    "com.amazonaws.textract#Textract",
    textract.new,
  )
}

pub fn apprunner_test() {
  helpers.test_endpoints(
    "./aws-models/apprunner.json",
    "com.amazonaws.apprunner#AppRunner",
    apprunner.new,
  )
}

pub fn cloudwatch_events_test() {
  helpers.test_endpoints(
    "./aws-models/cloudwatch-events.json",
    "com.amazonaws.cloudwatchevents#AWSEvents",
    cloudwatch_events.new,
  )
}

pub fn forecastquery_test() {
  helpers.test_endpoints(
    "./aws-models/forecastquery.json",
    "com.amazonaws.forecastquery#AmazonForecastRuntime",
    forecastquery.new,
  )
}

pub fn cloudtrail_test() {
  helpers.test_endpoints(
    "./aws-models/cloudtrail.json",
    "com.amazonaws.cloudtrail#CloudTrail_20131101",
    cloudtrail.new,
  )
}

pub fn cognito_identity_test() {
  helpers.test_endpoints(
    "./aws-models/cognito-identity.json",
    "com.amazonaws.cognitoidentity#AWSCognitoIdentityService",
    cognito_identity.new,
  )
}

pub fn qldb_session_test() {
  helpers.test_endpoints(
    "./aws-models/qldb-session.json",
    "com.amazonaws.qldbsession#QLDBSession",
    qldb_session.new,
  )
}

pub fn mturk_test() {
  helpers.test_endpoints(
    "./aws-models/mturk.json",
    "com.amazonaws.mturk#MTurkRequesterServiceV20170117",
    mturk.new,
  )
}

pub fn keyspaces_test() {
  helpers.test_endpoints(
    "./aws-models/keyspaces.json",
    "com.amazonaws.keyspaces#KeyspacesService",
    keyspaces.new,
  )
}

pub fn swf_test() {
  helpers.test_endpoints(
    "./aws-models/swf.json",
    "com.amazonaws.swf#SimpleWorkflowService",
    swf.new,
  )
}

pub fn marketplace_entitlement_service_test() {
  helpers.test_endpoints(
    "./aws-models/marketplace-entitlement-service.json",
    "com.amazonaws.marketplaceentitlementservice#AWSMPEntitlementService",
    marketplace_entitlement_service.new,
  )
}

pub fn ssm_contacts_test() {
  helpers.test_endpoints(
    "./aws-models/ssm-contacts.json",
    "com.amazonaws.ssmcontacts#SSMContacts",
    ssm_contacts.new,
  )
}

pub fn pi_test() {
  helpers.test_endpoints(
    "./aws-models/pi.json",
    "com.amazonaws.pi#PerformanceInsightsv20180227",
    pi.new,
  )
}

pub fn cost_and_usage_report_service_test() {
  helpers.test_endpoints(
    "./aws-models/cost-and-usage-report-service.json",
    "com.amazonaws.costandusagereportservice#AWSOrigamiServiceGatewayService",
    cost_and_usage_report_service.new,
  )
}

pub fn kinesis_test() {
  helpers.test_endpoints(
    "./aws-models/kinesis.json",
    "com.amazonaws.kinesis#Kinesis_20131202",
    kinesis.new,
  )
}

pub fn comprehend_test() {
  helpers.test_endpoints(
    "./aws-models/comprehend.json",
    "com.amazonaws.comprehend#Comprehend_20171127",
    comprehend.new,
  )
}

pub fn lightsail_test() {
  helpers.test_endpoints(
    "./aws-models/lightsail.json",
    "com.amazonaws.lightsail#Lightsail_20161128",
    lightsail.new,
  )
}

pub fn memorydb_test() {
  helpers.test_endpoints(
    "./aws-models/memorydb.json",
    "com.amazonaws.memorydb#AmazonMemoryDB",
    memorydb.new,
  )
}

pub fn config_service_test() {
  helpers.test_endpoints(
    "./aws-models/config-service.json",
    "com.amazonaws.configservice#StarlingDoveService",
    config_service.new,
  )
}

pub fn codepipeline_test() {
  helpers.test_endpoints(
    "./aws-models/codepipeline.json",
    "com.amazonaws.codepipeline#CodePipeline_20150709",
    codepipeline.new,
  )
}

pub fn timestream_write_test() {
  helpers.test_endpoints(
    "./aws-models/timestream-write.json",
    "com.amazonaws.timestreamwrite#Timestream_20181101",
    timestream_write.new,
  )
}

pub fn application_insights_test() {
  helpers.test_endpoints(
    "./aws-models/application-insights.json",
    "com.amazonaws.applicationinsights#EC2WindowsBarleyService",
    application_insights.new,
  )
}

pub fn global_accelerator_test() {
  helpers.test_endpoints(
    "./aws-models/global-accelerator.json",
    "com.amazonaws.globalaccelerator#GlobalAccelerator_V20180706",
    global_accelerator.new,
  )
}

pub fn resource_groups_tagging_api_test() {
  helpers.test_endpoints(
    "./aws-models/resource-groups-tagging-api.json",
    "com.amazonaws.resourcegroupstaggingapi#ResourceGroupsTaggingAPI_20170126",
    resource_groups_tagging_api.new,
  )
}

pub fn cloudcontrol_test() {
  helpers.test_endpoints(
    "./aws-models/cloudcontrol.json",
    "com.amazonaws.cloudcontrol#CloudApiService",
    cloudcontrol.new,
  )
}

pub fn kendra_test() {
  helpers.test_endpoints(
    "./aws-models/kendra.json",
    "com.amazonaws.kendra#AWSKendraFrontendService",
    kendra.new,
  )
}

pub fn service_catalog_test() {
  helpers.test_endpoints(
    "./aws-models/service-catalog.json",
    "com.amazonaws.servicecatalog#AWS242ServiceCatalogService",
    service_catalog.new,
  )
}

pub fn firehose_test() {
  helpers.test_endpoints(
    "./aws-models/firehose.json",
    "com.amazonaws.firehose#Firehose_20150804",
    firehose.new,
  )
}

pub fn forecast_test() {
  helpers.test_endpoints(
    "./aws-models/forecast.json",
    "com.amazonaws.forecast#AmazonForecast",
    forecast.new,
  )
}

pub fn kinesis_analytics_test() {
  helpers.test_endpoints(
    "./aws-models/kinesis-analytics.json",
    "com.amazonaws.kinesisanalytics#KinesisAnalytics_20150814",
    kinesis_analytics.new,
  )
}

pub fn rekognition_test() {
  helpers.test_endpoints(
    "./aws-models/rekognition.json",
    "com.amazonaws.rekognition#RekognitionService",
    rekognition.new,
  )
}

pub fn opensearchserverless_test() {
  helpers.test_endpoints(
    "./aws-models/opensearchserverless.json",
    "com.amazonaws.opensearchserverless#OpenSearchServerless",
    opensearchserverless.new,
  )
}

pub fn sqs_test() {
  helpers.test_endpoints(
    "./aws-models/sqs.json",
    "com.amazonaws.sqs#AmazonSQS",
    sqs.new,
  )
}

pub fn gamelift_test() {
  helpers.test_endpoints(
    "./aws-models/gamelift.json",
    "com.amazonaws.gamelift#GameLift",
    gamelift.new,
  )
}

pub fn kms_test() {
  helpers.test_endpoints(
    "./aws-models/kms.json",
    "com.amazonaws.kms#TrentService",
    kms.new,
  )
}

pub fn timestream_influxdb_test() {
  helpers.test_endpoints(
    "./aws-models/timestream-influxdb.json",
    "com.amazonaws.timestreaminfluxdb#AmazonTimestreamInfluxDB",
    timestream_influxdb.new,
  )
}

pub fn support_test() {
  helpers.test_endpoints(
    "./aws-models/support.json",
    "com.amazonaws.support#AWSSupport_20130415",
    support.new,
  )
}

pub fn sfn_test() {
  helpers.test_endpoints(
    "./aws-models/sfn.json",
    "com.amazonaws.sfn#AWSStepFunctions",
    sfn.new,
  )
}

pub fn opsworkscm_test() {
  helpers.test_endpoints(
    "./aws-models/opsworkscm.json",
    "com.amazonaws.opsworkscm#OpsWorksCM_V2016_11_01",
    opsworkscm.new,
  )
}

pub fn pricing_test() {
  helpers.test_endpoints(
    "./aws-models/pricing.json",
    "com.amazonaws.pricing#AWSPriceListService",
    pricing.new,
  )
}

pub fn codeconnections_test() {
  helpers.test_endpoints(
    "./aws-models/codeconnections.json",
    "com.amazonaws.codeconnections#CodeConnections_20231201",
    codeconnections.new,
  )
}

pub fn timestream_query_test() {
  helpers.test_endpoints(
    "./aws-models/timestream-query.json",
    "com.amazonaws.timestreamquery#Timestream_20181101",
    timestream_query.new,
  )
}

pub fn budgets_test() {
  helpers.test_endpoints(
    "./aws-models/budgets.json",
    "com.amazonaws.budgets#AWSBudgetServiceGateway",
    budgets.new,
  )
}

pub fn machine_learning_test() {
  helpers.test_endpoints(
    "./aws-models/machine-learning.json",
    "com.amazonaws.machinelearning#AmazonML_20141212",
    machine_learning.new,
  )
}

pub fn sms_test() {
  helpers.test_endpoints(
    "./aws-models/sms.json",
    "com.amazonaws.sms#AWSServerMigrationService_V2016_10_24",
    sms.new,
  )
}

pub fn network_firewall_test() {
  helpers.test_endpoints(
    "./aws-models/network-firewall.json",
    "com.amazonaws.networkfirewall#NetworkFirewall_20201112",
    network_firewall.new,
  )
}

pub fn emr_test() {
  helpers.test_endpoints(
    "./aws-models/emr.json",
    "com.amazonaws.emr#ElasticMapReduce",
    emr.new,
  )
}

pub fn ssm_test() {
  helpers.test_endpoints(
    "./aws-models/ssm.json",
    "com.amazonaws.ssm#AmazonSSM",
    ssm.new,
  )
}

pub fn kendra_ranking_test() {
  helpers.test_endpoints(
    "./aws-models/kendra-ranking.json",
    "com.amazonaws.kendraranking#AWSKendraRerankingFrontendService",
    kendra_ranking.new,
  )
}

pub fn license_manager_test() {
  helpers.test_endpoints(
    "./aws-models/license-manager.json",
    "com.amazonaws.licensemanager#AWSLicenseManager",
    license_manager.new,
  )
}

pub fn data_pipeline_test() {
  helpers.test_endpoints(
    "./aws-models/data-pipeline.json",
    "com.amazonaws.datapipeline#DataPipeline",
    data_pipeline.new,
  )
}

pub fn route53_recovery_cluster_test() {
  helpers.test_endpoints(
    "./aws-models/route53-recovery-cluster.json",
    "com.amazonaws.route53recoverycluster#ToggleCustomerAPI",
    route53_recovery_cluster.new,
  )
}

pub fn payment_cryptography_test() {
  helpers.test_endpoints(
    "./aws-models/payment-cryptography.json",
    "com.amazonaws.paymentcryptography#PaymentCryptographyControlPlane",
    payment_cryptography.new,
  )
}

pub fn transcribe_test() {
  helpers.test_endpoints(
    "./aws-models/transcribe.json",
    "com.amazonaws.transcribe#Transcribe",
    transcribe.new,
  )
}

pub fn snowball_test() {
  helpers.test_endpoints(
    "./aws-models/snowball.json",
    "com.amazonaws.snowball#AWSIESnowballJobManagementService",
    snowball.new,
  )
}

pub fn auto_scaling_plans_test() {
  helpers.test_endpoints(
    "./aws-models/auto-scaling-plans.json",
    "com.amazonaws.autoscalingplans#AnyScaleScalingPlannerFrontendService",
    auto_scaling_plans.new,
  )
}

pub fn codestar_test() {
  helpers.test_endpoints(
    "./aws-models/codestar.json",
    "com.amazonaws.codestar#CodeStar_20170419",
    codestar.new,
  )
}

pub fn dax_test() {
  helpers.test_endpoints(
    "./aws-models/dax.json",
    "com.amazonaws.dax#AmazonDAXV3",
    dax.new,
  )
}

pub fn iotfleetwise_test() {
  helpers.test_endpoints(
    "./aws-models/iotfleetwise.json",
    "com.amazonaws.iotfleetwise#IoTAutobahnControlPlane",
    iotfleetwise.new,
  )
}

pub fn iotthingsgraph_test() {
  helpers.test_endpoints(
    "./aws-models/iotthingsgraph.json",
    "com.amazonaws.iotthingsgraph#IotThingsGraphFrontEndService",
    iotthingsgraph.new,
  )
}

pub fn b2bi_test() {
  helpers.test_endpoints(
    "./aws-models/b2bi.json",
    "com.amazonaws.b2bi#B2BI",
    b2bi.new,
  )
}

pub fn service_quotas_test() {
  helpers.test_endpoints(
    "./aws-models/service-quotas.json",
    "com.amazonaws.servicequotas#ServiceQuotasV20190624",
    service_quotas.new,
  )
}

pub fn acm_pca_test() {
  helpers.test_endpoints(
    "./aws-models/acm-pca.json",
    "com.amazonaws.acmpca#ACMPrivateCA",
    acm_pca.new,
  )
}

pub fn marketplace_metering_test() {
  helpers.test_endpoints(
    "./aws-models/marketplace-metering.json",
    "com.amazonaws.marketplacemetering#AWSMPMeteringService",
    marketplace_metering.new,
  )
}

pub fn kinesis_analytics_v2_test() {
  helpers.test_endpoints(
    "./aws-models/kinesis-analytics-v2.json",
    "com.amazonaws.kinesisanalyticsv2#KinesisAnalytics_20180523",
    kinesis_analytics_v2.new,
  )
}

pub fn device_farm_test() {
  helpers.test_endpoints(
    "./aws-models/device-farm.json",
    "com.amazonaws.devicefarm#DeviceFarm_20150623",
    device_farm.new,
  )
}

pub fn redshift_data_test() {
  helpers.test_endpoints(
    "./aws-models/redshift-data.json",
    "com.amazonaws.redshiftdata#RedshiftData",
    redshift_data.new,
  )
}

pub fn glue_test() {
  helpers.test_endpoints(
    "./aws-models/glue.json",
    "com.amazonaws.glue#AWSGlue",
    glue.new,
  )
}

pub fn database_migration_service_test() {
  helpers.test_endpoints(
    "./aws-models/database-migration-service.json",
    "com.amazonaws.databasemigrationservice#AmazonDMSv20160101",
    database_migration_service.new,
  )
}

pub fn cognito_identity_provider_test() {
  helpers.test_endpoints(
    "./aws-models/cognito-identity-provider.json",
    "com.amazonaws.cognitoidentityprovider#AWSCognitoIdentityProviderService",
    cognito_identity_provider.new,
  )
}

pub fn directory_service_test() {
  helpers.test_endpoints(
    "./aws-models/directory-service.json",
    "com.amazonaws.directoryservice#DirectoryService_20150416",
    directory_service.new,
  )
}

pub fn cloudhsm_v2_test() {
  helpers.test_endpoints(
    "./aws-models/cloudhsm-v2.json",
    "com.amazonaws.cloudhsmv2#BaldrApiService",
    cloudhsm_v2.new,
  )
}

pub fn opsworks_test() {
  helpers.test_endpoints(
    "./aws-models/opsworks.json",
    "com.amazonaws.opsworks#OpsWorks_20130218",
    opsworks.new,
  )
}

pub fn codestar_connections_test() {
  helpers.test_endpoints(
    "./aws-models/codestar-connections.json",
    "com.amazonaws.codestarconnections#CodeStar_connections_20191201",
    codestar_connections.new,
  )
}

pub fn workspaces_test() {
  helpers.test_endpoints(
    "./aws-models/workspaces.json",
    "com.amazonaws.workspaces#WorkspacesService",
    workspaces.new,
  )
}

pub fn acm_test() {
  helpers.test_endpoints(
    "./aws-models/acm.json",
    "com.amazonaws.acm#CertificateManager",
    acm.new,
  )
}

pub fn inspector_test() {
  helpers.test_endpoints(
    "./aws-models/inspector.json",
    "com.amazonaws.inspector#InspectorService",
    inspector.new,
  )
}

pub fn ecs_test() {
  helpers.test_endpoints(
    "./aws-models/ecs.json",
    "com.amazonaws.ecs#AmazonEC2ContainerServiceV20141113",
    ecs.new,
  )
}

pub fn cloudhsm_test() {
  helpers.test_endpoints(
    "./aws-models/cloudhsm.json",
    "com.amazonaws.cloudhsm#CloudHsmFrontendService",
    cloudhsm.new,
  )
}

pub fn bcm_data_exports_test() {
  helpers.test_endpoints(
    "./aws-models/bcm-data-exports.json",
    "com.amazonaws.bcmdataexports#AWSBillingAndCostManagementDataExports",
    bcm_data_exports.new,
  )
}

pub fn shield_test() {
  helpers.test_endpoints(
    "./aws-models/shield.json",
    "com.amazonaws.shield#AWSShield_20160616",
    shield.new,
  )
}

pub fn application_discovery_service_test() {
  helpers.test_endpoints(
    "./aws-models/application-discovery-service.json",
    "com.amazonaws.applicationdiscoveryservice#AWSPoseidonService_V2015_11_01",
    application_discovery_service.new,
  )
}

pub fn organizations_test() {
  helpers.test_endpoints(
    "./aws-models/organizations.json",
    "com.amazonaws.organizations#AWSOrganizationsV20161128",
    organizations.new,
  )
}

pub fn route53resolver_test() {
  helpers.test_endpoints(
    "./aws-models/route53resolver.json",
    "com.amazonaws.route53resolver#Route53Resolver",
    route53resolver.new,
  )
}

pub fn sagemaker_test() {
  helpers.test_endpoints(
    "./aws-models/sagemaker.json",
    "com.amazonaws.sagemaker#SageMaker",
    sagemaker.new,
  )
}

pub fn comprehendmedical_test() {
  helpers.test_endpoints(
    "./aws-models/comprehendmedical.json",
    "com.amazonaws.comprehendmedical#ComprehendMedical_20181030",
    comprehendmedical.new,
  )
}

pub fn ecr_public_test() {
  helpers.test_endpoints(
    "./aws-models/ecr-public.json",
    "com.amazonaws.ecrpublic#SpencerFrontendService",
    ecr_public.new,
  )
}

pub fn direct_connect_test() {
  helpers.test_endpoints(
    "./aws-models/direct-connect.json",
    "com.amazonaws.directconnect#OvertureService",
    direct_connect.new,
  )
}

pub fn ec2_instance_connect_test() {
  helpers.test_endpoints(
    "./aws-models/ec2-instance-connect.json",
    "com.amazonaws.ec2instanceconnect#AWSEC2InstanceConnectService",
    ec2_instance_connect.new,
  )
}

pub fn dynamodb_streams_test() {
  helpers.test_endpoints(
    "./aws-models/dynamodb-streams.json",
    "com.amazonaws.dynamodbstreams#DynamoDBStreams_20120810",
    dynamodb_streams.new,
  )
}

pub fn pinpoint_sms_voice_v2_test() {
  helpers.test_endpoints(
    "./aws-models/pinpoint-sms-voice-v2.json",
    "com.amazonaws.pinpointsmsvoicev2#PinpointSMSVoiceV2",
    pinpoint_sms_voice_v2.new,
  )
}

pub fn freetier_test() {
  helpers.test_endpoints(
    "./aws-models/freetier.json",
    "com.amazonaws.freetier#AWSFreeTierService",
    freetier.new,
  )
}

pub fn identitystore_test() {
  helpers.test_endpoints(
    "./aws-models/identitystore.json",
    "com.amazonaws.identitystore#AWSIdentityStore",
    identitystore.new,
  )
}

pub fn migration_hub_test() {
  helpers.test_endpoints(
    "./aws-models/migration-hub.json",
    "com.amazonaws.migrationhub#AWSMigrationHub",
    migration_hub.new,
  )
}

pub fn ecr_test() {
  helpers.test_endpoints(
    "./aws-models/ecr.json",
    "com.amazonaws.ecr#AmazonEC2ContainerRegistry_V20150921",
    ecr.new,
  )
}

pub fn codebuild_test() {
  helpers.test_endpoints(
    "./aws-models/codebuild.json",
    "com.amazonaws.codebuild#CodeBuild_20161006",
    codebuild.new,
  )
}

pub fn servicediscovery_test() {
  helpers.test_endpoints(
    "./aws-models/servicediscovery.json",
    "com.amazonaws.servicediscovery#Route53AutoNaming_v20170314",
    servicediscovery.new,
  )
}

pub fn verifiedpermissions_test() {
  helpers.test_endpoints(
    "./aws-models/verifiedpermissions.json",
    "com.amazonaws.verifiedpermissions#VerifiedPermissions",
    verifiedpermissions.new,
  )
}

pub fn health_test() {
  helpers.test_endpoints(
    "./aws-models/health.json",
    "com.amazonaws.health#AWSHealth_20160804",
    health.new,
  )
}

pub fn transfer_test() {
  helpers.test_endpoints(
    "./aws-models/transfer.json",
    "com.amazonaws.transfer#TransferService",
    transfer.new,
  )
}

pub fn redshift_serverless_test() {
  helpers.test_endpoints(
    "./aws-models/redshift-serverless.json",
    "com.amazonaws.redshiftserverless#RedshiftServerless",
    redshift_serverless.new,
  )
}

pub fn cost_optimization_hub_test() {
  helpers.test_endpoints(
    "./aws-models/cost-optimization-hub.json",
    "com.amazonaws.costoptimizationhub#CostOptimizationHubService",
    cost_optimization_hub.new,
  )
}

pub fn wafv2_test() {
  helpers.test_endpoints(
    "./aws-models/wafv2.json",
    "com.amazonaws.wafv2#AWSWAF_20190729",
    wafv2.new,
  )
}

pub fn waf_regional_test() {
  helpers.test_endpoints(
    "./aws-models/waf-regional.json",
    "com.amazonaws.wafregional#AWSWAF_Regional_20161128",
    waf_regional.new,
  )
}

pub fn personalize_test() {
  helpers.test_endpoints(
    "./aws-models/personalize.json",
    "com.amazonaws.personalize#AmazonPersonalize",
    personalize.new,
  )
}

pub fn voice_id_test() {
  helpers.test_endpoints(
    "./aws-models/voice-id.json",
    "com.amazonaws.voiceid#VoiceID",
    voice_id.new,
  )
}

pub fn codedeploy_test() {
  helpers.test_endpoints(
    "./aws-models/codedeploy.json",
    "com.amazonaws.codedeploy#CodeDeploy_20141006",
    codedeploy.new,
  )
}

pub fn storage_gateway_test() {
  helpers.test_endpoints(
    "./aws-models/storage-gateway.json",
    "com.amazonaws.storagegateway#StorageGateway_20130630",
    storage_gateway.new,
  )
}

pub fn fsx_test() {
  helpers.test_endpoints(
    "./aws-models/fsx.json",
    "com.amazonaws.fsx#AWSSimbaAPIService_v20180301",
    fsx.new,
  )
}

pub fn application_auto_scaling_test() {
  helpers.test_endpoints(
    "./aws-models/application-auto-scaling.json",
    "com.amazonaws.applicationautoscaling#AnyScaleFrontendService",
    application_auto_scaling.new,
  )
}

pub fn compute_optimizer_test() {
  helpers.test_endpoints(
    "./aws-models/compute-optimizer.json",
    "com.amazonaws.computeoptimizer#ComputeOptimizerService",
    compute_optimizer.new,
  )
}

pub fn waf_test() {
  helpers.test_endpoints(
    "./aws-models/waf.json",
    "com.amazonaws.waf#AWSWAF_20150824",
    waf.new,
  )
}

pub fn marketplace_commerce_analytics_test() {
  helpers.test_endpoints(
    "./aws-models/marketplace-commerce-analytics.json",
    "com.amazonaws.marketplacecommerceanalytics#MarketplaceCommerceAnalytics20150701",
    marketplace_commerce_analytics.new,
  )
}

pub fn cloudwatch_logs_test() {
  helpers.test_endpoints(
    "./aws-models/cloudwatch-logs.json",
    "com.amazonaws.cloudwatchlogs#Logs_20140328",
    cloudwatch_logs.new,
  )
}

pub fn marketplace_agreement_test() {
  helpers.test_endpoints(
    "./aws-models/marketplace-agreement.json",
    "com.amazonaws.marketplaceagreement#AWSMPCommerceService_v20200301",
    marketplace_agreement.new,
  )
}

pub fn mailmanager_test() {
  helpers.test_endpoints(
    "./aws-models/mailmanager.json",
    "com.amazonaws.mailmanager#MailManagerSvc",
    mailmanager.new,
  )
}

pub fn fms_test() {
  helpers.test_endpoints(
    "./aws-models/fms.json",
    "com.amazonaws.fms#AWSFMS_20180101",
    fms.new,
  )
}

pub fn appstream_test() {
  helpers.test_endpoints(
    "./aws-models/appstream.json",
    "com.amazonaws.appstream#PhotonAdminProxyService",
    appstream.new,
  )
}

pub fn cost_explorer_test() {
  helpers.test_endpoints(
    "./aws-models/cost-explorer.json",
    "com.amazonaws.costexplorer#AWSInsightsIndexService",
    cost_explorer.new,
  )
}

pub fn secrets_manager_test() {
  helpers.test_endpoints(
    "./aws-models/secrets-manager.json",
    "com.amazonaws.secretsmanager#secretsmanager",
    secrets_manager.new,
  )
}

pub fn eventbridge_test() {
  helpers.test_endpoints(
    "./aws-models/eventbridge.json",
    "com.amazonaws.eventbridge#AWSEvents",
    eventbridge.new,
  )
}

pub fn workmail_test() {
  helpers.test_endpoints(
    "./aws-models/workmail.json",
    "com.amazonaws.workmail#WorkMailService",
    workmail.new,
  )
}

pub fn datasync_test() {
  helpers.test_endpoints(
    "./aws-models/datasync.json",
    "com.amazonaws.datasync#FmrsService",
    datasync.new,
  )
}

pub fn proton_test() {
  helpers.test_endpoints(
    "./aws-models/proton.json",
    "com.amazonaws.proton#AwsProton20200720",
    proton.new,
  )
}

pub fn migrationhub_config_test() {
  helpers.test_endpoints(
    "./aws-models/migrationhub-config.json",
    "com.amazonaws.migrationhubconfig#AWSMigrationHubMultiAccountService",
    migrationhub_config.new,
  )
}

pub fn translate_test() {
  helpers.test_endpoints(
    "./aws-models/translate.json",
    "com.amazonaws.translate#AWSShineFrontendService_20170701",
    translate.new,
  )
}

pub fn lookoutequipment_test() {
  helpers.test_endpoints(
    "./aws-models/lookoutequipment.json",
    "com.amazonaws.lookoutequipment#AWSLookoutEquipmentFrontendService",
    lookoutequipment.new,
  )
}

pub fn cloud9_test() {
  helpers.test_endpoints(
    "./aws-models/cloud9.json",
    "com.amazonaws.cloud9#AWSCloud9WorkspaceManagementService",
    cloud9.new,
  )
}

pub fn route_53_domains_test() {
  helpers.test_endpoints(
    "./aws-models/route-53-domains.json",
    "com.amazonaws.route53domains#Route53Domains_v20140515",
    route_53_domains.new,
  )
}

pub fn athena_test() {
  helpers.test_endpoints(
    "./aws-models/athena.json",
    "com.amazonaws.athena#AmazonAthena",
    athena.new,
  )
}

pub fn mediastore_test() {
  helpers.test_endpoints(
    "./aws-models/mediastore.json",
    "com.amazonaws.mediastore#MediaStore_20170901",
    mediastore.new,
  )
}

pub fn backup_gateway_test() {
  helpers.test_endpoints(
    "./aws-models/backup-gateway.json",
    "com.amazonaws.backupgateway#BackupOnPremises_v20210101",
    backup_gateway.new,
  )
}

pub fn frauddetector_test() {
  helpers.test_endpoints(
    "./aws-models/frauddetector.json",
    "com.amazonaws.frauddetector#AWSHawksNestServiceFacade",
    frauddetector.new,
  )
}

pub fn sso_admin_test() {
  helpers.test_endpoints(
    "./aws-models/sso-admin.json",
    "com.amazonaws.ssoadmin#SWBExternalService",
    sso_admin.new,
  )
}
