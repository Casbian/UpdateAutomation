function ThreadPool {
    $ThreadCount = [System.Environment]::ProcessorCount
    $ThreadPool  = [runspacefactory]::CreateRunspacePool(1, $ThreadCount)
    $ThreadPool.Open()
    return $ThreadPool
}