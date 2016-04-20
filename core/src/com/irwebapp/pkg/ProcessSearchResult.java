package com.irwebapp.pkg;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

public class ProcessSearchResult {
	String search;
	private final String USER_AGENT = "Mozilla/5.0 (Windows NT 5.1; rv:19.0) Gecko/20100101 Firefox/19.0";

	public ProcessSearchResult(String search) {
		this.search = search;
	}

	public String getContent() {
		String content = "";
		try {
			this.search = this.search.replaceAll(" ", "%20");
			String url = "http://10.202.156.150:8983/solr/gettingstarted_shard1_replica1/select?q="
					+ this.search + "&rows=10000000&wt=json&indent=true";
			URL obj = new URL(url);
			HttpURLConnection con = (HttpURLConnection) obj.openConnection();
			con.setRequestMethod("GET");
			con.setRequestProperty("User-Agent", USER_AGENT);

			int responseCode = con.getResponseCode();
			System.out.println("\nSending 'GET' request to URL : " + url);
			System.out.println("Response Code : " + responseCode);

			BufferedReader in = new BufferedReader(new InputStreamReader(
					con.getInputStream()));
			String inputLine;
			StringBuffer response = new StringBuffer();

			while ((inputLine = in.readLine()) != null) {
				response.append(inputLine);
			}
			in.close();
			content = response.toString();
		} catch (Exception e) {
			e.printStackTrace();
		}

		return content;

	}

}