<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="a" uri="/WEB-INF/app.tld"%>
<%@ taglib prefix="w" uri="http://www.unidal.org/web/core"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="res" uri="http://www.unidal.org/webres"%>
<jsp:useBean id="ctx"	type="com.dianping.cat.report.page.problem.Context"	scope="request" />
<jsp:useBean id="payload"	type="com.dianping.cat.report.page.problem.Payload"	scope="request" />
<jsp:useBean id="model"	type="com.dianping.cat.report.page.problem.Model" scope="request" />

<script>
	var errorTrend = ${model.errorTrend};
	var urlErrorTrend = ${model.urlErrorTrend};
	var longUrlTrend = ${model.longUrlTrend};	
	var longSqlTrend = ${model.longSqlTrend};
</script>

<a:historyReport title="History Report">

	<jsp:attribute name="subtitle">From ${w:format(payload.historyStartDate,'yyyy-MM-dd HH:mm:ss')} to ${w:format(payload.historyEndDate,'yyyy-MM-dd HH:mm:ss')}</jsp:attribute>
	<jsp:body>
	<res:useCss value="${res.css.local.problem_css}" target="head-css"/>
	<res:useJs value="${res.js.local['jquery-1.7.1.js']}" target="head-js" />
	<res:useJs value="${res.js.local.flotr2_js}" target="head-js" />
</br>
<table class="machines">
	<tr style="text-align:left">
		<th>Machines: &nbsp;[&nbsp; <c:choose>
				<c:when test="${model.ipAddress eq 'All'}">
					<a href="?op=history&domain=${model.domain}&date=${model.date}&threshold=${model.threshold}&ip=All"
						class="current">All</a>
				</c:when>
				<c:otherwise>
					<a href="?op=history&domain=${model.domain}&date=${model.date}&threshold=${model.threshold}&ip=All">All</a>
				</c:otherwise>
			</c:choose> &nbsp;]&nbsp; <c:forEach var="ip" items="${model.ips}">
   	  		&nbsp;[&nbsp;
   	  		<c:choose>
					<c:when test="${model.ipAddress eq ip}">
						<a href="?op=history&domain=${model.domain}&ip=${ip}&date=${model.date}&threshold=${model.threshold}"
							class="current">${ip}</a>
					</c:when>
					<c:otherwise>
						<a href="?op=history&domain=${model.domain}&ip=${ip}&date=${model.date}&threshold=${model.threshold}">${ip}</a>
					</c:otherwise>
				</c:choose>
   	 		&nbsp;]&nbsp;
			 </c:forEach>
		</th>
		<th>long-url <select size="1" id="p_longUrl">
				<option value="1000">1.0 Sec</option>
				<option value="1500">1.5 Sec</option>
				<option value="2000">2.0 Sec</option>
				<option value="3000">3.0 Sec</option>
				<option value="4000">4.0 Sec</option>
				<option value="5000">5.0 Sec</option>
		</select> <input style="WIDTH: 60px" value="Refresh"
			onclick="longTimeChange('${model.date}','${model.domain}','${model.ipAddress}')"
			type="submit">
		<script>
			var threshold='${model.threshold}';
			$("#p_longUrl").val(threshold) ;

			function longTimeChange(date,domain,ip){
				var longtime=$("#p_longUrl").val();
				window.location.href="?op=history&domain="+domain+"&ip="+ip+"&date="+date+"&threshold="+longtime;
			}
		</script>
		</th>
	</tr>
</table>

<br>
<table>
	<tr>
		<th>Type</th>
		<th>Total</th>
		<th>Status</th>
		<th>Count</th>
		<th>SampleLinks</th>
	</tr>
	<c:forEach var="statistics" items="${model.allStatistics.status}"
		varStatus="typeIndex">
		<tr>
			<td rowspan="${w:size(statistics.value.status)}"
				class="${typeIndex.index mod 2 != 0 ? 'even' : 'odd'} top">
				<a href="?op=historyGraph&domain=${model.domain}&date=${model.date}&ip=${model.ipAddress}&reportType=${model.reportType}&type=${statistics.value.type}" class="history_graph_link" data-status="${status.index}">[:: show ::]</a>
				<a href="#" class="${statistics.value.type}">&nbsp;&nbsp;</a>
				&nbsp;&nbsp;${statistics.value.type}
			</td>
			<td rowspan="${w:size(statistics.value.status)}"
				class="${typeIndex.index mod 2 != 0 ? 'even' : 'odd'} top">${statistics.value.count}</td>
			<c:forEach var="status" items="${statistics.value.status}"
				varStatus="index">
				<c:if test="${index.index != 0}">
					<tr>
				</c:if>
				<td class="${index.index mod 2 != 0 ? 'even' : 'odd'}">${status.value.status}</td>
				<td class="${index.index mod 2 != 0 ? 'even' : 'odd'}">${status.value.count}</td>
				<td class="${index.index mod 2 != 0 ? 'even' : 'odd'}"><c:forEach
						var="links" items="${status.value.links}" varStatus="linkIndex">
						<a href="${model.logViewBaseUri}/${links}">${linkIndex.first?'L':(linkIndex.last?'g':'o')}</a>
					</c:forEach></td>
				<c:if test="${index.index != 0}">
		</tr>
		</c:if>
	</c:forEach>
	</tr>
	</c:forEach>
</table>
</br>

<table>
	<tr>
		<td><div id="errorTrend" class="graph"></div>	</td>
		<td><div id="urlErrorTrend" class="graph"></div>	</td>
	</tr>
		<tr>
		<td><div id="longUrlTrend" class="graph"></div>	</td>
		<td><div id="longSqlTrend" class="graph"></div>	</td>
	</tr>
</table>

<res:useJs value="${res.js.local.problemHistory_js}" target="bottom-js" />
</jsp:body>

</a:historyReport>