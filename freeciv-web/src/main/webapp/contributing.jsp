<%@ include file="/WEB-INF/jsp/fragments/i18n.jsp"%>
<!DOCTYPE html>
<html lang="en">
<head>
	<%@include file="/WEB-INF/jsp/fragments/head.jsp"%>
<style>
.accounting {
 margin-bottom:20px;
}
.accounting th, .accounting td {
 padding:8px;
 vertical-align:bottom;
 border-bottom:1px solid #be602d;
 line-height:1.4em;
}
.accounting>tbody {
 border-top:2px solid #be602d
}
.accounting tr>td:last-child {
 text-align: right;
}
</style>
</head>
	<div class="container">
		<%@include file="/WEB-INF/jsp/fragments/header.jsp"%>
		<h2>Bug reports, feature requests, ideas, code, art</h2>
		<p>You can find this site's code (not config or data) in the <a href="https://github.com/lonemadmax/freeciv-web/tree/movingborders">GitHub repo</a>. But that's just a bunch of cosmetic changes from <a href="https://github.com/freeciv/freeciv-web/">upstream</a>, which is probably where you should go.</p>
		<p>For game engine related stuff, <a href="http://www.hostedredmine.com/projects/freeciv">Freeciv</a> is your target.</p>
		<p>You may also help other projects that fuel this and many other sites, like <a href="https://tomcat.apache.org/">Apache Tomcat</a>, <a href="https://nginx.org/">nginx</a> or <a href="https://www.debian.org/">Debian</a>.</p>
		<h2>Money</h2>
		<p>You can still help if all you have is money. Everybody loves your money.</p>
		<p>For this site, you can send one time contributions through <a href="https://www.paypal.me/mcrcc">PayPal</a>. It should be free for most of Europe using EUR. You can find a more or less up to date report of income and expenses below.</p>
		<p>On the other hand, this is something temporal and if it disappears before a year it won't be due to money. So unless there's value in having both this site and the community one, your money may be better spent supporting the One True Community Site. Or an <a href="https://www.patreon.com/zeko">admin/developer behind it</a>.</p>
		<p><a href="http://www.freeciv.org/donate.html">Freeciv</a> may also thank your appreciation</p>
		<p>And if you are filthy rich, you may hire developers and artists to do what you can't.</p>
		<h3>Income and expenses</h3>
		<p>Last updated: 2018-12-16</p>
		<h4>Lifetime total</h4>
		<table class="accounting">
			<tr><th scope="row">Future expected payments</th><td>-341,64</td></tr>
			<tr><th scope="row">Past real payments</th><td>-65,23</td></tr>
			<tr><th scope="row">Donations</th><td>0,00</td></tr>
		</table>
		<h4>2019</h4>
		<table class="accounting">
		<tbody>
			<tr><td></td><th scope="row">Future expected payments</th><td>-341,64</td></tr>
			<tr><td></td><th scope="row">Past real payments</th><td>0,00</td></tr>
			<tr><td></td><th scope="row">Donations</th><td>0,00</td></tr>
		</tbody>
		<tbody>
			<tr><td>2019-12-14</td><td>Server</td><td>-28,47</td></tr>
			<tr><td>2019-11-14</td><td>Server</td><td>-28,47</td></tr>
			<tr><td>2019-10-14</td><td>Server</td><td>-28,47</td></tr>
			<tr><td>2019-09-14</td><td>Server</td><td>-28,47</td></tr>
			<tr><td>2019-08-14</td><td>Server</td><td>-28,47</td></tr>
			<tr><td>2019-07-14</td><td>Server</td><td>-28,47</td></tr>
			<tr><td>2019-06-14</td><td>Server</td><td>-28,47</td></tr>
			<tr><td>2019-05-14</td><td>Server</td><td>-28,47</td></tr>
			<tr><td>2019-04-14</td><td>Server</td><td>-28,47</td></tr>
			<tr><td>2019-03-14</td><td>Server</td><td>-28,47</td></tr>
			<tr><td>2019-02-14</td><td>Server</td><td>-28,47</td></tr>
			<tr><td>2019-01-14</td><td>Server</td><td>-28,47</td></tr>
		</tbody>
		</table>
		<h4>2018</h4>
		<table class="accounting">
		<tbody>
			<tr><td></td><th scope="row">Future expected payments</th><td>0,00</td></tr>
			<tr><td></td><th scope="row">Past real payments</th><td>-65,23</td></tr>
			<tr><td></td><th scope="row">Donations</th><td>0,00</td></tr>
		</tbody>
		<tbody>
			<tr><td>2018-12-14</td><td>PayPal rebate</td><td>5,00</td></tr>
			<tr><td>2018-12-14</td><td>Server</td><td>-28,47</td></tr>
			<tr><td>2018-11-14</td><td>Server</td><td>-28,47</td></tr>
			<tr><td>2018-11-14</td><td>Domain registry</td><td>-13,29</td></tr>
		</tbody>
		</table>
		<%@include file="/WEB-INF/jsp/fragments/footer.jsp"%>
	</div>
</body>
</html>
