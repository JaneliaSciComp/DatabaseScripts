<?php

/*
 * This file is part of pgFouine.
 * 
 * pgFouine - a PostgreSQL log analyzer
 * Copyright (c) 2006 Guillaume Smet
 *
 * pgFouine is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or (at
 * your option) any later version.
 *
 * pgFouine is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with pgFouine; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street - Fifth Floor, Boston, MA  02110-1301, USA.
 */

class QueriesHistoryReport extends Report {
	function QueriesHistoryReport(& $reportAggregator) {
		$this->Report($reportAggregator, 'Queries history', array('QueriesHistoryListener'));
	}
	
	function getText() {
		$listener =& $this->reportAggregator->getListener('QueriesHistoryListener');
		$text = '';
		
		$queries =& $listener->getQueriesHistory();
		$count = count($queries);
		for($i = 0; $i < $count; $i++) {
			$query =& $queries[$i];
			$text .= ($i+1).') '.$this->formatTimestamp($query->getTimestamp()).' - '.$this->formatDuration($query->getDuration()).' - '.$this->formatRealQuery($query)."\n";
			$text .= "--\n";
			
			unset($query);
		}
		return $text;
	}
	
	function getHtml() {
		$listener =& $this->reportAggregator->getListener('QueriesHistoryListener');
		$html = '
<table class="queryList">
	<tr>
		<th>Rank</th>
		<th>Time</th>
		<th>Query</th>
		<th>Duration&nbsp;('.CONFIG_DURATION_UNIT.')</th>
	</tr>';
		$queries =& $listener->getQueriesHistory();
		$count = count($queries);
		for($i = 0; $i < $count; $i++) {
			$query =& $queries[$i];
			$title = $query->getDetailedInformation();
			
			$html .= '<tr class="'.$this->getRowStyle($i).'">
				<td class="center top">'.($i+1).'</td>
				<td class="top center">'.$this->formatTimestamp($query->getTimestamp()).'</td>
				<td title="'.$query->getDetailedInformation().'">'.$this->formatRealQuery($query).'</td>
				<td class="top center">'.$this->formatDuration($query->getDuration()).'</td>
			</tr>';
			$html .= "\n";
			
			unset($query);
		}
		$html .= '</table>';
		return $html;
	}
}

?>