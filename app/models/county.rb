class County < ActiveRecord::Base
  require 'mechanize'

  def fetch_file
    agent = Mechanize.new
    page = agent.get("http://www.voterfind.com/#{name.downcase}oh/avreport.aspx")
    form = page.form('frmvtlook')
    form.radiobuttons_with(:name => 'grp_output')[2].check
    page = agent.submit(form)
  end
end
