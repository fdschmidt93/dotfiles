function sjobs --wraps='squeue -O "jobid" | tail -n +2 | xargs -n1 scontrol show job | rg "(JobId)|(RunTime)|(SubmitTime)|(StartTime)|(Partition)|(Command)"' --description 'alias sjobs squeue -O "jobid" | tail -n +2 | xargs -n1 scontrol show job | rg "(JobId)|(RunTime)|(SubmitTime)|(StartTime)|(Partition)|(Command)"'
  squeue -O "jobid" | tail -n +2 | xargs -n1 scontrol show job | rg "(JobId)|(RunTime)|(SubmitTime)|(StartTime)|(Partition)|(Command)" $argv; 
end
