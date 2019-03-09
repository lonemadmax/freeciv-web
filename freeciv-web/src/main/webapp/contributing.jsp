<%@ include file="/WEB-INF/jsp/fragments/i18n.jsp"%>
<!DOCTYPE html>
<html lang="en">
<head>
	<%@include file="/WEB-INF/jsp/fragments/head.jsp"%>
<script>
$(document).ready(function () {
  $.getJSON('/data/accounting.json', function(data) {
    function newYear(year) {
      return {
          year: year
        , futurePayments: 0
        , pastPayments: 0
        , donations: 0
        , entries: []
      };
    }
    var yearData = [];
    var total = newYear(0);
    var currentYear = newYear(data.accounting[0][0].substring(0, 4));
    yearData.push(currentYear);

    var dl = data.accounting.length;
    for (var i = 0; i < dl; i++) {
      var entry = data.accounting[i];
      var year = entry[0].substring(0, 4);
      if (year != currentYear.year) {
        total.futurePayments += currentYear.futurePayments;
        total.pastPayments += currentYear.pastPayments;
        total.donations += currentYear.donations;
        currentYear = newYear(year);
        yearData.push(currentYear);
      }
      if (entry[3] == "-") {
        if (entry[0] <= data.lastUpdate) {
          currentYear.pastPayments += entry[2];
        } else {
          currentYear.futurePayments += entry[2];
        }
      } else {
        currentYear.donations += entry[2];
      }
      currentYear.entries.push(entry);
    }
    total.futurePayments += currentYear.futurePayments;
    total.pastPayments += currentYear.pastPayments;
    total.donations += currentYear.donations;
    yearData.push(currentYear);

    var accEl = document.getElementById("accounting");

    var el = document.createElement("p");
    el.appendChild(document.createTextNode("Last updated: " + data.lastUpdate));
    accEl.appendChild(el);

    function addYearTitle(year) {
      var el = document.createElement("h4");
      el.appendChild(document.createTextNode(year));
      accEl.appendChild(el);
    }

    function addAccountingTable(yearData) {
      function formatMoney(value) {
        var t;
        var q = Math.abs(value);
        if (q >= 100) {
          t = "" + q;
          var iDigits = t.length - 2;
          t = t.substring(0, iDigits) + "," + t.substring(iDigits);
        } else if (q >= 10) {
          t = "0," + q;
        } else {
          t = "0,0" + q;
        }
        return (value >= 0 ? t : ("-" + t));
      }

      function summaryRow(title, value) {
        var row = document.createElement("tr");
        var cell = document.createElement("td");
        row.appendChild(cell);
        cell = document.createElement("th");
        cell.setAttribute("scope", "row");
        cell.appendChild(document.createTextNode(title));
        row.appendChild(cell);
        cell = document.createElement("td");
        cell.appendChild(document.createTextNode(formatMoney(value)));
        row.appendChild(cell);
        return row;
      }

      var table = document.createElement("table");
      table.setAttribute("class", "accounting");
      var tbody = document.createElement("tbody");
      tbody.appendChild(summaryRow("Future expected payments", yearData.futurePayments));
      tbody.appendChild(summaryRow("Past real payments", yearData.pastPayments));
      tbody.appendChild(summaryRow("Donations", yearData.donations));
      table.appendChild(tbody);
      var iEntry = yearData.entries.length;
      if (iEntry > 0) {
        tbody = document.createElement("tbody");
        while (iEntry--) {
          var entry = yearData.entries[iEntry];
          var row = document.createElement("tr");
          var cell = document.createElement("td");
          cell.appendChild(document.createTextNode(entry[0]));
          row.appendChild(cell);
          cell = document.createElement("td");
          cell.appendChild(document.createTextNode(entry[1]));
          row.appendChild(cell);
          cell = document.createElement("td");
          cell.appendChild(document.createTextNode(formatMoney(entry[2])));
          row.appendChild(cell);
          tbody.appendChild(row);
        }
        table.appendChild(tbody);
      }
      accEl.appendChild(table);
    }

    addYearTitle("Lifetime total");
    addAccountingTable(total);

    for (var i = yearData.length - 1; i--; i >= 0) {
      addYearTitle(yearData[i].year);
      addAccountingTable(yearData[i]);
    }
  });
});
</script>
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
		<div id="accounting"></div>
		<%@include file="/WEB-INF/jsp/fragments/footer.jsp"%>
	</div>
</body>
</html>
