pipeline {
    agent any

    parameters {
        booleanParam(name: 'DRY_RUN', defaultValue: true, description: 'List actions only, do not delete')
        string(name: 'CACHE_ROOT', defaultValue: '/var/jenkins_home/git-cache', description: 'Path to cached Git repos')
        booleanParam(name: 'CLEAN_WORKSPACES', defaultValue: false, description: 'Clean old Jenkins workspaces')
        booleanParam(name: 'AGGRESSIVE', defaultValue: false, description: 'Run aggressive Git cleanup')
    }

    environment {
        AGE_DAYS = '30'
        WORKSPACE_ROOT = '/var/jenkins_home/workspace'
    }

    stages {
        stage('Preparation') {
            steps {
                echo "🚀 Starting Git cache maintenance (DRY_RUN=${params.DRY_RUN})"
                sh 'date; whoami; df -h'
            }
        }

        stage('Disk Check') {
            steps {
                sh 'bash scripts/disk_check.sh || true'
            }
        }

        stage('Git Cache Cleanup') {
            steps {
                sh 'bash scripts/git_cleanup.sh "${CACHE_ROOT}" "${DRY_RUN}" "${AGGRESSIVE}" "${AGE_DAYS}"'
            }
        }

        stage('Workspace Cleanup (optional)') {
            when { expression { params.CLEAN_WORKSPACES } }
            steps {
                sh 'bash scripts/workspace_cleanup.sh "${WORKSPACE_ROOT}" "${DRY_RUN}" "${AGE_DAYS}"'
            }
        }
    }

    post {
        always {
            echo "✅ Git cache maintenance completed."
            archiveArtifacts artifacts: 'git_repos_list', allowEmptyArchive: true
        }
    }
}
