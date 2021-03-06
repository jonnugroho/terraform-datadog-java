resource "datadog_timeboard" "java" {
  title       = "${var.product_domain} - ${var.cluster} - ${var.environment} - Java"
  description = "A generated timeboard for Java"

  template_variable {
    default = "${var.cluster}"
    name    = "cluster"
    prefix  = "cluster"
  }

  template_variable {
    default = "${var.environment}"
    name    = "environment"
    prefix  = "environment"
  }

  graph {
    title     = "Heap Memory"
    viz       = "timeseries"
    autoscale = true

    request {
      q    = "max:jvm.heap_memory{$cluster, $environment} by {host}"
      type = "line"
    }

    request {
      q    = "max:jvm.heap_memory_max{$cluster, $environment} by {host}"
      type = "line"
    }
  }

  graph {
    title     = "Old Gen"
    viz       = "timeseries"
    autoscale = true

    request {
      q    = "avg:jmx.java.lang.usage.used{$cluster, $environment,name:cms_old_gen} by {host}"
      type = "line"
    }

    request {
      q    = "avg:jmx.java.lang.usage.max{$cluster, $environment,name:cms_old_gen} by {host}"
      type = "line"
    }

    request {
      q    = "avg:jmx.java.lang.usage.used{$cluster, $environment,name:ps_old_gen} by {host}"
      type = "line"
    }

    request {
      q    = "avg:jmx.java.lang.usage.max{$cluster, $environment,name:ps_old_gen} by {host}"
      type = "line"
    }
  }

  graph {
    title     = "Perm Gen / Metaspace"
    viz       = "timeseries"
    autoscale = true

    request {
      q    = "avg:jmx.java.lang.usage.used{$cluster, $environment,name:cms_perm_gen} by {host}"
      type = "line"
    }

    request {
      q    = "avg:jmx.java.lang.usage.max{$cluster, $environment,name:cms_perm_gen} by {host}"
      type = "line"
    }

    request {
      q    = "avg:jmx.java.lang.usage.used{$cluster, $environment,name:ps_perm_gen} by {host}"
      type = "line"
    }

    request {
      q    = "avg:jmx.java.lang.usage.max{$cluster, $environment,name:ps_perm_gen} by {host}"
      type = "line"
    }

    request {
      q    = "avg:jmx.java.lang.usage.used{$cluster, $environment,name:metaspace} by {host}"
      type = "line"
    }

    request {
      q    = "avg:jmx.java.lang.usage.max{$cluster, $environment,name:metaspace} by {host}"
      type = "line"
    }
  }

  graph {
    title     = "Survivor / Eden Space"
    viz       = "timeseries"
    autoscale = true

    request {
      q    = "avg:jmx.java.lang.usage.used{$cluster, $environment,name:par_survivor_space} by {host}"
      type = "line"
    }

    request {
      q    = "avg:jmx.java.lang.usage.max{$cluster, $environment,name:par_survivor_space} by {host}"
      type = "line"
    }

    request {
      q    = "avg:jmx.java.lang.usage.used{$cluster, $environment,name:ps_eden_space} by {host}"
      type = "line"
    }

    request {
      q    = "avg:jmx.java.lang.usage.max{$cluster, $environment,name:ps_eden_space} by {host}"
      type = "line"
    }
  }

  graph {
    title     = "GC Marksweep / Concurrent-Marksweep Count per Minute"
    viz       = "timeseries"
    autoscale = true

    request {
      q    = "per_minute(avg:jmx.java.lang.collection_count{$cluster, $environment,name:concurrentmarksweep} by {host,name})"
      type = "line"
    }

    request {
      q    = "per_minute(avg:jmx.java.lang.collection_count{$cluster, $environment,name:ps_marksweep} by {host,name})"
      type = "line"
    }
  }

  graph {
    title     = "GC Parnew / Scavenge Count per Minute"
    viz       = "timeseries"
    autoscale = true

    request {
      q    = "per_minute(avg:jmx.java.lang.collection_count{$cluster, $environment,name:parnew} by {host,name})"
      type = "line"
    }

    request {
      q    = "per_minute(avg:jmx.java.lang.collection_count{$cluster, $environment,name:ps_scavenge} by {host,name})"
      type = "line"
    }
  }

  graph {
    title     = "Thread Runnable"
    viz       = "timeseries"
    autoscale = true

    request {
      q    = "avg:Thread.RUNNABLE{$cluster, $environment} by {host,threadname}"
      type = "line"
    }
  }

  graph {
    title     = "Thread Blocked"
    viz       = "timeseries"
    autoscale = true

    request {
      q    = "avg:Thread.BLOCKED{$cluster, $environment} by {host,threadname}"
      type = "line"
    }
  }

  graph {
    title     = "ScheduledExecutor Queue Count"
    viz       = "timeseries"
    autoscale = true

    request {
      q    = "avg:ScheduledExecutor.QueuedCount{$cluster, $environment} by {host,threadname}"
      type = "line"
    }
  }

  graph {
    title     = "Avg Warm Up Per Host"
    viz       = "query_value"
    custom_unit = "S"
    precision = 0

    request {
      q    = "avg:warmup.elapsedTime{success:true,appgroup:${var.service}} by {host}/1000"
      type = "bars"
      conditional_format {
        comparator = "<"
        value       = 120
        palette     = "white_on_green"
      }
      conditional_format {
        comparator = "<"
        value       = 180
        palette     = "white_on_yellow"
      }
      conditional_format {
        comparator = ">"
        value       = 300
        palette     = "white_on_red"
      }
    }
  }
}
