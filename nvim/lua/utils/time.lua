local M = {}

M.format_ago = function(time_1, time_2)
  local secs_diff = os.difftime(time_1, time_2)

  if secs_diff < 0 then
    return ""
  end

  if secs_diff < 60 then
    return string.format("%d sec%s ago", secs_diff, (secs_diff > 1) and "s" or "")
  end

  local mins_diff = math.floor(secs_diff / 60)
  if mins_diff < 60 then
    return string.format("%d min%s ago", mins_diff, (mins_diff > 1) and "s" or "")
  end

  local hrs_diff = math.floor(mins_diff / 60)
  if hrs_diff < 24 then
    return string.format("%d hr%s ago", hrs_diff, (hrs_diff > 1) and "s" or "")
  end

  local days_diff = math.floor(hrs_diff / 24)

  return string.format("%d day%s ago", days_diff, (days_diff > 1) and "s" or "")
end

return M
