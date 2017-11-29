//
//  XML_Parser.swift
//  AutoMaintenance
//
//  Created by Carissa on 11/27/17.
//  Copyright © 2017 Carissa. All rights reserved.
//

import Foundation



class FeedParser: NSObject, XMLParserDelegate {
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
    }
    
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
    }
    
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {

    }
    
    
    func parserDidEndDocument(_ parser: XMLParser) {
        
    }
    
}
