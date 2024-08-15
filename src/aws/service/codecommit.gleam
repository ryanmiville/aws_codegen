import aws/aws
import aws/client.{type Client}
import aws/config.{type Config}
import aws/internal/endpoint

const content_type = "application/x-amz-json-1.1"

const endpoint_prefix = "codecommit"

const service_id = "CodeCommit_20150413"

const signing_name = "codecommit"

pub fn new(config: Config) -> Client {
  let endpoint = endpoint.resolve(config, endpoint_prefix)
  client.Client(config, service_id, signing_name, endpoint)
}

pub fn associate_approval_rule_template_with_repository(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(
    client,
    "AssociateApprovalRuleTemplateWithRepository",
    request_body,
    content_type,
  )
}

pub fn batch_associate_approval_rule_template_with_repositories(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(
    client,
    "BatchAssociateApprovalRuleTemplateWithRepositories",
    request_body,
    content_type,
  )
}

pub fn batch_describe_merge_conflicts(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(
    client,
    "BatchDescribeMergeConflicts",
    request_body,
    content_type,
  )
}

pub fn batch_disassociate_approval_rule_template_from_repositories(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(
    client,
    "BatchDisassociateApprovalRuleTemplateFromRepositories",
    request_body,
    content_type,
  )
}

pub fn batch_get_commits(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "BatchGetCommits", request_body, content_type)
}

pub fn batch_get_repositories(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "BatchGetRepositories", request_body, content_type)
}

pub fn create_approval_rule_template(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(
    client,
    "CreateApprovalRuleTemplate",
    request_body,
    content_type,
  )
}

pub fn create_branch(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "CreateBranch", request_body, content_type)
}

pub fn create_commit(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "CreateCommit", request_body, content_type)
}

pub fn create_pull_request(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "CreatePullRequest", request_body, content_type)
}

pub fn create_pull_request_approval_rule(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(
    client,
    "CreatePullRequestApprovalRule",
    request_body,
    content_type,
  )
}

pub fn create_repository(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "CreateRepository", request_body, content_type)
}

pub fn create_unreferenced_merge_commit(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(
    client,
    "CreateUnreferencedMergeCommit",
    request_body,
    content_type,
  )
}

pub fn delete_approval_rule_template(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(
    client,
    "DeleteApprovalRuleTemplate",
    request_body,
    content_type,
  )
}

pub fn delete_branch(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "DeleteBranch", request_body, content_type)
}

pub fn delete_comment_content(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "DeleteCommentContent", request_body, content_type)
}

pub fn delete_file(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "DeleteFile", request_body, content_type)
}

pub fn delete_pull_request_approval_rule(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(
    client,
    "DeletePullRequestApprovalRule",
    request_body,
    content_type,
  )
}

pub fn delete_repository(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "DeleteRepository", request_body, content_type)
}

pub fn describe_merge_conflicts(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "DescribeMergeConflicts", request_body, content_type)
}

pub fn describe_pull_request_events(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(
    client,
    "DescribePullRequestEvents",
    request_body,
    content_type,
  )
}

pub fn disassociate_approval_rule_template_from_repository(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(
    client,
    "DisassociateApprovalRuleTemplateFromRepository",
    request_body,
    content_type,
  )
}

pub fn evaluate_pull_request_approval_rules(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(
    client,
    "EvaluatePullRequestApprovalRules",
    request_body,
    content_type,
  )
}

pub fn get_approval_rule_template(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(
    client,
    "GetApprovalRuleTemplate",
    request_body,
    content_type,
  )
}

pub fn get_blob(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "GetBlob", request_body, content_type)
}

pub fn get_branch(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "GetBranch", request_body, content_type)
}

pub fn get_comment(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "GetComment", request_body, content_type)
}

pub fn get_comment_reactions(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "GetCommentReactions", request_body, content_type)
}

pub fn get_comments_for_compared_commit(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(
    client,
    "GetCommentsForComparedCommit",
    request_body,
    content_type,
  )
}

pub fn get_comments_for_pull_request(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(
    client,
    "GetCommentsForPullRequest",
    request_body,
    content_type,
  )
}

pub fn get_commit(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "GetCommit", request_body, content_type)
}

pub fn get_differences(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "GetDifferences", request_body, content_type)
}

pub fn get_file(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "GetFile", request_body, content_type)
}

pub fn get_folder(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "GetFolder", request_body, content_type)
}

pub fn get_merge_commit(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "GetMergeCommit", request_body, content_type)
}

pub fn get_merge_conflicts(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "GetMergeConflicts", request_body, content_type)
}

pub fn get_merge_options(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "GetMergeOptions", request_body, content_type)
}

pub fn get_pull_request(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "GetPullRequest", request_body, content_type)
}

pub fn get_pull_request_approval_states(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(
    client,
    "GetPullRequestApprovalStates",
    request_body,
    content_type,
  )
}

pub fn get_pull_request_override_state(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(
    client,
    "GetPullRequestOverrideState",
    request_body,
    content_type,
  )
}

pub fn get_repository(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "GetRepository", request_body, content_type)
}

pub fn get_repository_triggers(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "GetRepositoryTriggers", request_body, content_type)
}

pub fn list_approval_rule_templates(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(
    client,
    "ListApprovalRuleTemplates",
    request_body,
    content_type,
  )
}

pub fn list_associated_approval_rule_templates_for_repository(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(
    client,
    "ListAssociatedApprovalRuleTemplatesForRepository",
    request_body,
    content_type,
  )
}

pub fn list_branches(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "ListBranches", request_body, content_type)
}

pub fn list_file_commit_history(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "ListFileCommitHistory", request_body, content_type)
}

pub fn list_pull_requests(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "ListPullRequests", request_body, content_type)
}

pub fn list_repositories(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "ListRepositories", request_body, content_type)
}

pub fn list_repositories_for_approval_rule_template(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(
    client,
    "ListRepositoriesForApprovalRuleTemplate",
    request_body,
    content_type,
  )
}

pub fn list_tags_for_resource(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "ListTagsForResource", request_body, content_type)
}

pub fn merge_branches_by_fast_forward(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(
    client,
    "MergeBranchesByFastForward",
    request_body,
    content_type,
  )
}

pub fn merge_branches_by_squash(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "MergeBranchesBySquash", request_body, content_type)
}

pub fn merge_branches_by_three_way(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(
    client,
    "MergeBranchesByThreeWay",
    request_body,
    content_type,
  )
}

pub fn merge_pull_request_by_fast_forward(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(
    client,
    "MergePullRequestByFastForward",
    request_body,
    content_type,
  )
}

pub fn merge_pull_request_by_squash(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(
    client,
    "MergePullRequestBySquash",
    request_body,
    content_type,
  )
}

pub fn merge_pull_request_by_three_way(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(
    client,
    "MergePullRequestByThreeWay",
    request_body,
    content_type,
  )
}

pub fn override_pull_request_approval_rules(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(
    client,
    "OverridePullRequestApprovalRules",
    request_body,
    content_type,
  )
}

pub fn post_comment_for_compared_commit(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(
    client,
    "PostCommentForComparedCommit",
    request_body,
    content_type,
  )
}

pub fn post_comment_for_pull_request(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(
    client,
    "PostCommentForPullRequest",
    request_body,
    content_type,
  )
}

pub fn post_comment_reply(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "PostCommentReply", request_body, content_type)
}

pub fn put_comment_reaction(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "PutCommentReaction", request_body, content_type)
}

pub fn put_file(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "PutFile", request_body, content_type)
}

pub fn put_repository_triggers(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "PutRepositoryTriggers", request_body, content_type)
}

pub fn tag_resource(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "TagResource", request_body, content_type)
}

pub fn test_repository_triggers(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "TestRepositoryTriggers", request_body, content_type)
}

pub fn untag_resource(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "UntagResource", request_body, content_type)
}

pub fn update_approval_rule_template_content(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(
    client,
    "UpdateApprovalRuleTemplateContent",
    request_body,
    content_type,
  )
}

pub fn update_approval_rule_template_description(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(
    client,
    "UpdateApprovalRuleTemplateDescription",
    request_body,
    content_type,
  )
}

pub fn update_approval_rule_template_name(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(
    client,
    "UpdateApprovalRuleTemplateName",
    request_body,
    content_type,
  )
}

pub fn update_comment(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "UpdateComment", request_body, content_type)
}

pub fn update_default_branch(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "UpdateDefaultBranch", request_body, content_type)
}

pub fn update_pull_request_approval_rule_content(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(
    client,
    "UpdatePullRequestApprovalRuleContent",
    request_body,
    content_type,
  )
}

pub fn update_pull_request_approval_state(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(
    client,
    "UpdatePullRequestApprovalState",
    request_body,
    content_type,
  )
}

pub fn update_pull_request_description(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(
    client,
    "UpdatePullRequestDescription",
    request_body,
    content_type,
  )
}

pub fn update_pull_request_status(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(
    client,
    "UpdatePullRequestStatus",
    request_body,
    content_type,
  )
}

pub fn update_pull_request_title(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "UpdatePullRequestTitle", request_body, content_type)
}

pub fn update_repository_description(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(
    client,
    "UpdateRepositoryDescription",
    request_body,
    content_type,
  )
}

pub fn update_repository_encryption_key(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(
    client,
    "UpdateRepositoryEncryptionKey",
    request_body,
    content_type,
  )
}

pub fn update_repository_name(
  client: Client,
  request_body: BitArray,
) -> Result(BitArray, aws.Error) {
  client.post_json(client, "UpdateRepositoryName", request_body, content_type)
}
