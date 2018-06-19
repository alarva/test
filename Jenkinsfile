node("aws-linux") {
    properties([disableConcurrentBuilds()])
	properties([gitLabConnection('my-company_Gitalb')])

	// Parameters section

	jenkins_project_name = "Front"

	// Defaults
    clean_env			= true
    scm_checkout		= true
    scm_quality         = true
    build_app 			= true
    deps_check			= true
    test_quality 		= true
    functional_test 	= true
    release_branch      = false
    increase_patch_v    = false
    smoke_test 			= false
    deploy_ecs_sb 		= false
    regression_test 	= false
    app_deploy_pre 		= false
    app_deploy_pro 		= false
    pre_merge_branch 	= false

    // Conditionals

    // Getting branches properties
        switch (env.BRANCH_NAME) {
            case ~/^feature\/[a-zA-Z0-9\-_\.]*$/:
                testing_strategy = "core"
                pre_merge_branch = "develop"
                break
            case ~/^develop$/:
                testing_strategy = "core"
                app_deploy_pre = true
                break
            case ~/^master$/:
                testing_strategy = "core"
                app_deploy_pro = true
                break
            case ~/^release\/[a-zA-Z0-9\-_\.]*$/:
                testing_strategy = "core"
                break
            default:
                currentBuild.result = 'FAILURE'
                error("[FAILURE] Unsupported branch type - ${env.BRANCH_NAME}")
                break
        }

    // Getting job properties (override branch properties)
    echo "Checking job properties for: ${env.JOB_NAME}"
    switch (env.JOB_NAME) {
            case ~/^MyCompany\/${jenkins_project_name}\/Deploy-Sandbox.*/:
                pre_merge_branch = false
                test_quality = false
                deps_check = false
                functional_test = false
                deploy_ecs_sb = true
                release_branch = false
                app_deploy_pre = false
                app_deploy_pro = false
                echo "We will build a sandbox in AWS ECS."
                break
            case ~/^MyCompany\/${jenkins_project_name}\/Increase-Patch-Version.*/:
                release_branch = false
                echo "We only will increase the patch version."
                break
            case ~/^MyCompany\/${jenkins_project_name}\/Create-Release-Package/:
                release_branch = true
                echo "We will deploy to nexus a new release package"
                break
            default:
                echo "There is no special rules for this job."
                break
        }

	jenkins_base_path = "https://myamazingdemo.com/jenkins"

	// Main Code repository
	git_url_code = "https://myamazingdemo.com/gitlab/my-company/web-front-angular4.git"
	git_cred_code = "DEVOPS_LAB_GIT_JENKINS_BOT"
	git_folder_code = "sources"

	// Scripts repository
	git_enable_scripts = true
	git_url_scripts = "https://myamazingdemo.com/gitlab/my-company/scripts.git"
	git_cred_scripts = "DEVOPS_LAB_GIT_JENKINS_BOT"
	git_folder_scripts = "scripts"

	// Ansible site repository
	git_enable_ansible = true
	git_url_ansible = "https://myamazingdemo.com/gitlab/my-company/ansible-site.git"
	git_cred_ansible = "DEVOPS_LAB_GIT_JENKINS_BOT"
	git_folder_ansible = "ansible"

	// Testing docker repository
	git_enable_docker = true
	git_url_docker = "https://myamazingdemo.com/gitlab/docker/lamp.git"
	git_cred_docker = "DEVOPS_LAB_GIT_JENKINS_BOT"
	git_folder_docker = "docker_lamp"

	// Build parameters
	build_script = "/bin/bash scripts/bin/build_front_angular4.sh"
	artifact_id = "front"
	archive_build_artifact = "artifacts/front.tar"
	tagalize_script_path = "scripts/bin/tagalize.sh"

	// Nexus parameters
	nexus_credentialsId = "DEVOPS_LAB_NEXUS_JENKINS_BOT"
	nexus_groupId = 'org.my-company'
	nexus_url = 'myamazingdemo.com/nexus'
	nexus_version = 'nexus2'
	nexus_protocol = 'https'
	nexus_repository = 'app-packages'
	nexus_artifact_type = 'war'

	// Jira release manager
  jira_credentials_id = "JIRA_BOT_USER"
  jira_package_name = "MyCompany Front"
  jira_project_name = "MAD"
  jira_api_url = "https://myamazingdemo.com/jira/rest/api/latest/version"

	// Functional testing
	functional_test_script = "/bin/bash scripts/bin/tests_functional.sh -t core -p front_build_test_docker.sh -o destroy_test_docker.sh"
	archive_tests_artifact = "sources/tests/results/*"
	cucumber_fileIncludePattern = '*.json'
	cucumber_fileExcludePattern = ''
	cucumber_jsonReportDirectory = 'sources/tests/results/'
	junit_location = 'sources/tests/results/*.xml'

	// Sandbox section
	deploy_ecs_sandbox_script = "/bin/bash scripts/bin/front_build_test_ecs.sh -r 507707319576.dkr.ecr.eu-central-1.amazonaws.com -d 30"

	// Deploy section
	deploy_app_pre_script = "cd ansible && chmod 755 inventory/ec2.py && ansible-playbook deploy.my-company-front.yml -i inventory/ec2.py --extra-vars \"local_artifact=\\\"${WORKSPACE}/artifacts/front.tar\\\" deploy_env=test\""
	deploy_app_pro_script = "cd ansible && chmod 755 inventory/ec2.py && ansible-playbook deploy.my-company-front.yml -i inventory/ec2.py --extra-vars \"local_artifact=\\\"${WORKSPACE}/artifacts/front.tar\\\" deploy_env=prod\""

	// Project custom parameters
	jenkins_folder = "pipeline"
	jenkins_project = "my-company"
	jenkins_app = "my-company"


	stage("Preparing to build branch - ${env.BRANCH_NAME}") {
		echo "Cleaning workspace"
		deleteDir()

		// Checkout Jenkinsfiles
		echo "Checkout Jenkins pipeline-as-code repository..."
		checkout([
				$class                           : 'GitSCM', branches: [
				[name: '*/master']
		],
				doGenerateSubmoduleConfigurations: false,
				extensions                       : [
						[$class: "RelativeTargetDirectory", relativeTargetDir: "jenkins"]
				],
				submoduleCfg                     : [],
				userRemoteConfigs                : [
						[credentialsId: "DEVOPS_LAB_GIT_JENKINS_BOT",
						 url          : "https://myamazingdemo.com/gitlab/${jenkins_project}/jenkins.git"]
				]
		])
	}

	if (build_app == true) updateGitlabCommitStatus name: 'build', state: 'pending'
	if (functional_test == true) updateGitlabCommitStatus name: 'test', state: 'pending'
	if (app_deploy_pre == true) updateGitlabCommitStatus name: 'deploy', state: 'pending'
	if (app_deploy_pro == true) updateGitlabCommitStatus name: 'deploy', state: 'pending'
	if (release_branch == true) updateGitlabCommitStatus name: 'deploy', state: 'pending'

	if (scm_checkout == true) load "jenkins/${jenkins_folder}/${jenkins_app}/scm_app.groovy"
	if (increase_patch_v == true) load "jenkins/${jenkins_folder}/${jenkins_app}/increase-patch-version.groovy"
	if (deps_check == true) load "jenkins/${jenkins_folder}/${jenkins_app}/deps_check.groovy"
	if (test_quality == true) load "jenkins/${jenkins_folder}/${jenkins_app}/test_quality_app.groovy"
	if (build_app == true) load "jenkins/${jenkins_folder}/${jenkins_app}/build_app.groovy"
	if (functional_test == true) load "jenkins/${jenkins_folder}/${jenkins_app}/functional_test.groovy"
	if (deploy_ecs_sb == true) load "jenkins/${jenkins_folder}/${jenkins_app}/deploy_ecs_sandbox.groovy"
	if (app_deploy_pre == true) load "jenkins/${jenkins_folder}/${jenkins_app}/deploy_app_pre.groovy"
	if (app_deploy_pro == true) load "jenkins/${jenkins_folder}/${jenkins_app}/deploy_app_pro.groovy"
	if (release_branch == true) load "jenkins/${jenkins_folder}/${jenkins_app}/deploy_release_nexus.groovy"
}
