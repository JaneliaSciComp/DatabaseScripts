<?php

/*
 * This file is part of pgFouine.
 * 
 * pgFouine - a PostgreSQL log analyzer
 * Copyright (c) 2005-2006 Guillaume Smet
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

class PostgreSQLAccumulator extends Accumulator {
	var $working = array();
	var $stream;
	
	function PostgreSQLAccumulator() {
		$this->stream = new LogStream();
	}

	function append(& $line) {
		if($connectionId = $line->getConnectionId()) {
			if(!isset($this->working[$connectionId])) {
				$this->working[$connectionId] = new LogStream();
			}
			$query =& $this->working[$connectionId]->append($line);
		} else {
			$query =& $this->stream->append($line);
		}
		if($query) {
			$query->accumulateTo($this);
		}
	}
	
	function flushLogStreams() {
		// flush default stream
		$this->stream->flush($this);
		
		// flush streams with connection id
		$logStreamsKeys = array_keys($this->working);
		foreach($logStreamsKeys AS $key) {
			$logStream =& $this->working[$key];
			$logStream->flush($this);
			unset($logStream);
		}
	}
}

?>