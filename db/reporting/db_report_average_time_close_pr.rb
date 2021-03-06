
class AveragePrCloseDbReporter < DbReporter

  def name()
    return "Average Pull Request Close Time"
  end

  def report_class()
    return 'issue-report'
  end

  def describe()
    return "This report shows the average time each repo takes to close pull requests"
  end

  def db_columns()
    return [ ['Repo', 'org/repo'], "Count of closed pull requests", "Average time to close pull requests" ]
  end

  def db_report(context, org, sync_db)

    text = ""
    pr_query="SELECT repo, COUNT(id), ROUND(AVG( julianday(closed_at) - julianday(created_at) ), 1) as mttr FROM pull_requests WHERE state='closed' AND org=? GROUP BY org, repo ORDER BY mttr"

    pr_data=sync_db.execute(pr_query, [org])
    pr_data.each() do |row|
        text << "  <reporting class='issue-report' repo='#{org}/#{row[0]}' type='AveragePrCloseDbReporter'><field>#{org}/#{row[0]}</field><field>#{row[1]}</field><field>#{row[2]}</field></reporting>\n"
    end

    return text
  end

end
