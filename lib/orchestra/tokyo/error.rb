module Orchestra
  module Tokyo
    class Error < StandardError
      UID_GEN      = "Unable to generate a unique id"
      DELETE       = "Unable to delete the record with UID : %s"
      PUT          = "Unable to put %s (%s)"
    end
  end
end
