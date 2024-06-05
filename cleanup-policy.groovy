import org.sonatype.nexus.cleanup.storage.CleanupPolicyStorage
import org.sonatype.nexus.cleanup.storage.CleanupPolicyComponent

def createPolicy (policyName) {
    // 30 day retention on last download
    Integer retention = (30 * 24 * 60 * 60)
    try {
        def policyStorage = container.lookup(CleanupPolicyStorage.class.getName())
        def cleanupPolicy = policyStorage.newCleanupPolicy()
        cleanupPolicy.setName(policyName)
        cleanupPolicy.setNotes('')
        cleanupPolicy.setMode('deletion')
        cleanupPolicy.setFormat('docker')
        cleanupPolicy.setCriteria(['lastDownloaded': retention.toString(),'regex': '.*cera-.*'])
        policyStorage.add(cleanupPolicy)
    } catch (e) {
        log.info("Cleanup policy already exists, skipping...")
        log.warning(e.dump())
    }

}

def attachPolicy (policyName, repositoryName) {
    try {
        def repo = repository.repositoryManager.get(repositoryName)
        def cleanupPolicyAttribute = [policyName: [policyName].toSet()]
        def conf = repo.getConfiguration()
        conf.getAttributes().put("cleanup", cleanupPolicyAttribute)
        repo.stop()
        repo.update(conf)
        repo.start()
    } catch (e) {
        log.info("Attaching policy fail")
        log.warning(e.dump())
    }
}

def deletePolicy(String name) {
    def cleanupPolicyStorage = container.lookup(CleanupPolicyStorage.class.getName())
    def cleanupPolicyComponent = container.lookup(CleanupPolicyComponent.class.getName())
    if (cleanupPolicyStorage.exists(name)) {
        log.info("matching policy name found")
        cleanupPolicyStorage.remove(cleanupPolicyStorage.get(name))
        return true
    }
    log.warn("deleting policy fail")
    return false
}

deletePolicy('dockerCleanupPolicy') //allows changes to existing
createPolicy('dockerCleanupPolicy')
//attachPolicy('dockerCleanupPolicy', 'cera-hosted')